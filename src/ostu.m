%二值化
function img_bin = ostu(img) %img 为灰度图
    show_details=0;
%    img = rgb2gray(img);
%    figure
%    imshow(img); title('二值化前');
    
    count=imhist(img); %灰度直方图
    [row,col]= size(img);
    count = count/(row*col);%归一化
%    figure 
%    plot(count); title('灰度直方图');

    u=sum((1:256)*count(1:256)); %整幅图像的均值

    %找到灰度级的边界
    L=256;
    for i=1:L
       if(count(i)~=0) 
           st=i; break; end
    end
    for i=L:-1:1
       if(count(i)~=0) 
           nd=i; break; end
    end

    w0 = zeros(1,256); %前景像素比例
    u0 = zeros(1,256); %前景像素期望
    g  = zeros(1,256);
    for t=st:nd
        w0(t)=sum(count(st:t)); %前t个像素的累加概率
        u0(t)=sum((st:t)*count(st:t))/w0(t);%前t个像素的像素期望值
    end
    for t=st:nd
       g(t)=w0(t)*(u-u0(t))^2/(1-w0(t));%计算类间方差g(t)
    end
%{
    figure;
    subplot(3,1,1); plot(g); title('g');
    subplot(3,1,2); plot(w0); title('w0');
    subplot(3,1,3); plot(u0); title('u0');
%}
    %求使得g(t)最大的t值
    max_g = max(g);
    for i=1:256
       if(g(i) == max_g) 
           t=i; break; %计算所得的最佳阈值
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
        imshow(img_bin); title(['二值化后（阈值:',num2str(t),')']);
        
        level = graythresh(img);
        bw = im2bw(img,level);
        level = level*255; %标准阈值
        figure
        imshow(bw); title(['im2bw的输出(阈值：',num2str(level),'）']);  
    end    
end

