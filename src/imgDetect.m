%��ά��Ķ�λ�Ͳü�
%��main2�Ļ�������һЩ�Ż���
%1��ͨ�����ұ�ķ���ȥ����߽���������ͨ��
%2����ȡͼ���Ϊ
%    ��ȥ��С�����ͨ���ʣ�µĲ���
%    ����ԭͼ��������õ���ά��ȥ��������
%    ��ͨ��ͶӰ��λȷ����ά����������
%    �ٽ��вü��õ��ɾ��Ķ�ά��

%�����ֵ�����ͼ������ü����Ķ�ά��
function img_417 = imgDetect(img_bin) 
    show_detail = 1;%Ϊ1ʱ��ʾ�м���
%% ��ͼ���������,��ǿ��ͨ��
    dilate_times = 1;

    dilate_structor1 = [1,0,0,0,1; 
                        0,1,1,1,0; 
                        0,1,1,1,0;
                        0,1,1,1,0;
                        1,0,0,0,1];
    erode_structor1 = [0,1,0;
                       1,1,1;
                       0,1,0];

%    dilate_structor1 = struDiskGenerator(4);
%    erode_structor1  = struDiskGenerator(4);
   img_dilate = img_bin;
    for i = 1:dilate_times
       img_dilate = imgDilate(img_dilate,dilate_structor1); 
       img_dilate = imgErode(img_dilate,erode_structor1);
    end

    %% ��ȡ�߽�
    [rows,cols]=size(img_dilate);
    %marker��ʼ��Ϊԭͼ�ı߽�
    marker = uint8(zeros(rows,cols));
    marker(1:2,:)=img_dilate(1:2,:);
    marker(rows-1:rows,:)=img_dilate(rows-1:rows,:);
    marker(:,1:2)=img_dilate(:,1:2);
    marker(:,cols-1:cols)=img_dilate(:,cols-1:cols);

    %% �������ұ�
    [img_label,num_label] = bwlabel(img_dilate, 8);

    %% ͨ�����ұ�ȥ����߽���������ͨ��
    img_label2 = img_label;
    for r_m = 1:rows  
    for c_m = 1:cols   %����ԭͼ�߽磨marker��
       if(marker(r_m,c_m)==1) %���ڱ߽��ϵ�ÿ��ǰ�����أ�
          num = img_label(r_m,c_m); %�ҵ��������ڵ���ͨ��
          if(num > 0) 
              for r = 1:rows
              for c = 1:cols
				%����ͨͼ��img_label�������ڸ���ͨ��ĵ㶼Ĩ��
                if(img_label(r,c)==num) 
                    img_label2(r,c) = 0;
                end
              end
              end
          end
       end
    end
    end

    %%
    if(show_detail==1)
        figure('Name','imgDetecet'); 
        subplot(121); imshow(img_bin);title('����ͼ��');
        subplot(122); imshow(img_dilate); title([num2str(dilate_times),'�����͸�ʴ���ͼ��']);
        figure('Name','imgDetecet'); 
        subplot(221); image(img_label/num_label*255, 'CDataMapping','scaled'); colorbar; title('��ͨͼ');
        subplot(222); image(img_label2/num_label*255, 'CDataMapping','scaled'); colorbar; title('ȥ����߽���������ͨ���');
    end

    %% ͨ�����ұ�ȥ��С�����ͨ��

    %ͳ��ÿ����ͨ��Ĵ�С
    [rows,cols] = size(img_label2);
    connected_size = zeros(num_label,1);
    for r = 1:rows
        for c = 1:cols
           num = img_label2(r,c);
           if(num>0)
               connected_size(num) = connected_size(num)+1;
           end
        end    
    end

    %����ͨ���С��ͨ�����ֵ
    connected_threshold = max(connected_size)/2;

    %ȥ��С�����ͨ��
    img_label3 = img_label2;
    for r = 1:rows
       for c = 1:cols
           num = img_label2(r,c);%��ǰ��������ͨ��ı��
           if(num > 0 && connected_size(num) < connected_threshold)
               img_label3(r,c) = 0;
           end
       end
    end

    if(show_detail==1)
       subplot(223);image(img_label3/num_label*255, 'CDataMapping','scaled'); colorbar;  title('ȥ��С�����ͨ���');
       subplot(224); plot(connected_size); title(['ÿ����ͨ��Ĵ�С����',num2str(num_label),'�� ,��ֵ:',num2str(connected_threshold),'��']);
    end

    %% ͶӰ��λ,��ȡ��ά��
    
    %Ϊ�˱���ͶӰ��λ��ȡ����ͼ���������ȶ�ͼ�����������չ��ά��߽�
    img_label_extend = logical(img_label3);
    img_label_extend = imgDilate(img_label_extend,ones(5,5));

    %ͶӰ��λ
    map_row = zeros(1,rows); %ǰ��������ÿһ���ϵ�ͶӰ
    map_col = zeros(1,cols); %��ÿһ���ϵ�ͶӰ

    for r = 1:rows
        map_row(r) = sum(img_label_extend(r,:));
        if(r>1)%ƽ������ S(k) = 0.7S(k) + 0.3S(k+1)
           map_row(r-1) = 0.7*map_row(r-1)+0.3*map_row(r); 
        end
    end
    for c = 1:cols
       map_col(c) = sum(img_label_extend(:,c)); 
        if(c>1)%ƽ������ S(k) = 0.7S(k) + 0.3S(k+1)
           map_col(c-1) = 0.7*map_col(c-1)+0.3*map_col(c); 
        end   
    end

    %map_row_mean = mean(map_row);
    %map_col_mean = mean(map_col);
    map_row_mean = 0;
    map_col_mean = 0;
    map_interval = [0,0,0,0];%�������������
    for r = 1:rows
       if(map_row(r)>map_row_mean)%��һ��������ֵ��������Ϊ�������
           map_interval(1) = r; break;
       end
    end
    for r = rows:-1:1
       if(map_row(r)>map_row_mean)%��һ��������ֵ��������Ϊ�����յ�
           map_interval(2) = r; break;
       end
    end

    for c = 1:cols
       if(map_col(c)>map_col_mean)%��һ��������ֵ��������Ϊ�������
           map_interval(3) = c; break;
       end
    end
    for c = cols:-1:1
       if(map_col(c)>map_col_mean)%��һ��������ֵ��������Ϊ�����յ�
           map_interval(4) = c; break;
       end
    end

    %ȥ������
    img_417_0 = img_bin & img_label3;   
    %��ȡ
    img_417_1 = logical(img_417_0(map_interval(1):map_interval(2),map_interval(3):map_interval(4)));
    
    %Ϊ�˱��ں�������ͼƬ������չ
    [rows,cols] = size(img_417_1);
    extend_size = 30;
    img_417 = zeros(rows+extend_size*2,cols+extend_size*2);
    img_417(1+extend_size:rows+extend_size,1+extend_size:cols+extend_size) = img_417_1;

    %%
    if(show_detail ==1)
        figure('Name','imgDetecet');
        subplot(221); plot(map_row, 'r-.'); 
        hold on;      plot(map_col, 'g');
        legend('���ϵ�ͶӰ','���ϵ�ͶӰ');
        hold off;
        subplot(222); imshow(img_417_1); title('��ȡ����pdf417');

        subplot(223); imshow(img_bin); hold on;
        plot([1,cols],[map_interval(1),map_interval(1)],'r');
        plot([1,cols],[map_interval(2),map_interval(2)],'r');
        plot([map_interval(3),map_interval(3)],[1,rows],'r');
        plot([map_interval(4),map_interval(4)],[1,rows],'r');
        hold off; title('��ά����������');
    end
end
