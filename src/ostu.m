%��ֵ��
function img_bin = ostu(img) %img Ϊ�Ҷ�ͼ
    show_details=0;
%    img = rgb2gray(img);
%    figure
%    imshow(img); title('��ֵ��ǰ');
    
    count=imhist(img); %�Ҷ�ֱ��ͼ
    [row,col]= size(img);
    count = count/(row*col);%��һ��
%    figure 
%    plot(count); title('�Ҷ�ֱ��ͼ');

    u=sum((1:256)*count(1:256)); %����ͼ��ľ�ֵ

    %�ҵ��Ҷȼ��ı߽�
    L=256;
    for i=1:L
       if(count(i)~=0) 
           st=i; break; end
    end
    for i=L:-1:1
       if(count(i)~=0) 
           nd=i; break; end
    end

    w0 = zeros(1,256); %ǰ�����ر���
    u0 = zeros(1,256); %ǰ����������
    g  = zeros(1,256);
    for t=st:nd
        w0(t)=sum(count(st:t)); %ǰt�����ص��ۼӸ���
        u0(t)=sum((st:t)*count(st:t))/w0(t);%ǰt�����ص���������ֵ
    end
    for t=st:nd
       g(t)=w0(t)*(u-u0(t))^2/(1-w0(t));%������䷽��g(t)
    end
%{
    figure;
    subplot(3,1,1); plot(g); title('g');
    subplot(3,1,2); plot(w0); title('w0');
    subplot(3,1,3); plot(u0); title('u0');
%}
    %��ʹ��g(t)����tֵ
    max_g = max(g);
    for i=1:256
       if(g(i) == max_g) 
           t=i; break; %�������õ������ֵ
       end
    end

    img_bin = uint8(zeros(row,col));
    for r=1:row
        for c=1:col
            if(img(r,c)>t)
                img_bin(r,c)=255; 
            else
                img_bin(r,c)=0;
            end
        end
    end
%%
    if(show_details==1)
        figure('Name','ostu');
        imshow(img_bin); title(['��ֵ������ֵ:',num2str(t),')']);
        
        level = graythresh(img);
        bw = im2bw(img,level);
        level = level*255; %��׼��ֵ
        figure
        imshow(bw); title(['im2bw�����(��ֵ��',num2str(level),'��']);  
    end    
end

