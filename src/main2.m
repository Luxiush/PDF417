%��ά��Ķ�λ�Ͳü�
%% sec-1-1 ��ȡͼ�񣬲����ж�ֵ��
%img_in = imread('../img/7.png'); 
img_in = imread('../img/test-1.png'); 
img_gray = rgb2gray(img_in);

img_bin = ostu(img_gray);

%��Ϊ֮ǰ��Ƶ����͡���ʴ������Ĭ��1Ϊǰ��ɫ������ά���ǰ��ɫ��0�������Ƚ��з�ת��
img_bin = ~logical(img_bin); 

%% sec-1-2 ��ͼ���������,��ǿ��ͨ��
dilate_times = 1;
dilate_structor1 = [1,0,0,0,1; 
                    0,1,1,1,0; 
                    0,1,1,1,0;
                    0,1,1,1,0;
                    1,0,0,0,1];
erode_structor1 = [0,1,0;
                   1,1,1;
                   0,1,0];
img_dilate = img_bin;
for i = 1:dilate_times
   img_dilate = imgDilate(img_dilate,dilate_structor1); 
   img_dilate = imgErode(img_dilate,erode_structor1);
end

%% sec-1-3 �Ա߽�������ͣ��ع�
[rows,cols]=size(img_dilate);
%marker��ʼ��Ϊԭͼ�ı߽�
marker = zeros(rows,cols);
marker(1,:)=img_dilate(1,:);
marker(rows,:)=img_dilate(rows,:);
marker(:,1)=img_dilate(:,1);
marker(:,cols)=img_dilate(:,cols);

structor_size = 5;
reconstruct_structor = ones(structor_size);%�ṹԪ��
%���ʹ��� = ���ı߽���(��Ϊͼ���ȵ�50%)/ÿ�����͵ĵ���(floor(structor_size/2));
reconstruct_times = ceil((0.5*cols)/floor(structor_size/2));%�߽��ع�����
for i = 1:reconstruct_times
    marker = imgDilate(marker,reconstruct_structor);%�Ա߽��������
    marker = marker&img_dilate;%���ͺ���ԭͼȡ���� 
end

%ȥ����߽���������ͨ��
img_connect = img_dilate - marker;

%%
figure; 
subplot(221); imshow(img_bin);title('��ת��Ķ�ֵͼ��');
subplot(222); imshow(img_dilate); title([num2str(dilate_times),'�����͸�ʴ���ͼ��']);
subplot(223); imshow(marker);title(['�߽�����',num2str(reconstruct_times),'�κ�']);
subplot(224); imshow(img_connect);title('ȥ����߽���������ͨ���');

%------------------------------------------------------------------------------------%
%% sec-2-1  �������ұ�ȥ��С�����ͨ��
[img_label,num_label] = bwlabel(img_connect, 8);

%ͳ��ÿ����ͨ��Ĵ�С
[rows,cols] = size(img_label);
connected_size = zeros(num_label,1);
for r = 1:rows
    for c = 1:cols
       i = img_label(r,c);
       if(i>0)
           connected_size(i) = connected_size(i)+1;
       end
    end    
end

%����ͨ���С��ͨ�����ֵ
connected_threshold = max(connected_size)/2;

%ȥ��С�����ͨ��
img_label2 = img_label;
for r = 1:rows
   for c = 1:cols
       num = img_label2(r,c);%��ǰ��������ͨ��ı��
       if(num > 0 && connected_size(num) < connected_threshold)
           img_label2(r,c) = 0;
       end
   end
end

%%
figure; 
subplot(221); image(img_label/num_label*255, 'CDataMapping','scaled'); colorbar; title('��ͨͼ');
subplot(222); plot(connected_size); title(['ÿ����ͨ��Ĵ�С����',num2str(num_label),'����']);
subplot(223); image(img_label2, 'CDataMapping','scaled'); colorbar; title('ȥ��С�����ͨ���');

%% sec-2-2 Ϊ�˱���ͶӰ��λ��ȡ����ͼ���������ȶ�ͼ�����������չ��ά��߽�
img_label2 = imgDilate(img_label2,reconstruct_structor);

%------------------------------------------------------------------------------------%
%% sec-3-1  ͶӰ��λ,��ȡ��ά��
    %ͶӰ��λ
img_417 = logical(img_label2);
map_row = zeros(1,rows); %ǰ��������ÿһ���ϵ�ͶӰ
map_col = zeros(1,cols); %��ÿһ���ϵ�ͶӰ

for r = 1:rows
    map_row(r) = sum(img_417(r,:));
    if(r>1)%ƽ������ S(k) = 0.7S(k) + 0.3S(k+1)
       map_row(r-1) = 0.7*map_row(r-1)+0.3*map_row(r); 
    end
end
for c = 1:cols
   map_col(c) = sum(img_417(:,c)); 
    if(c>1)%ƽ������ S(k) = 0.7S(k) + 0.3S(k+1)
       map_col(c-1) = 0.7*map_col(c-1)+0.3*map_col(c); 
    end   
end

%map_row_mean = mean(map_row);
%map_col_mean = mean(map_col);
map_row_mean = 0;
map_col_mean = 0;
map_intervel = [0,0,0,0];%�������������
for r = 1:rows
   if(map_row(r)>map_row_mean)%��һ��������ֵ��������Ϊ�������
       map_intervel(1) = r; break;
   end
end
for r = rows:-1:1
   if(map_row(r)>map_row_mean)%��һ��������ֵ��������Ϊ�����յ�
       map_intervel(2) = r; break;
   end
end

for c = 1:cols
   if(map_col(c)>map_col_mean)%��һ��������ֵ��������Ϊ�������
       map_intervel(3) = c; break;
   end
end
for c = cols:-1:1
   if(map_col(c)>map_col_mean)%��һ��������ֵ��������Ϊ�����յ�
       map_intervel(4) = c; break;
   end
end

img_4170 = img_label2&img_bin;
    %��ȡ
img_417 = img_4170(map_intervel(1):map_intervel(2),map_intervel(3):map_intervel(4));

    %Ϊ�˱��ں�������ͼƬ������չ
    extend_size = 60;
    [rows,cols] = size(img_417);
    img_4171 = zeros(rows+extend_size*2,cols+extend_size*2);
    img_4171(1+extend_size:rows+extend_size,1+extend_size:cols+extend_size) = img_417;

%%
figure;
subplot(221); plot(map_row, 'r-.'); 
hold on;      plot(map_col, 'g');
legend('���ϵ�ͶӰ','���ϵ�ͶӰ');
hold off;
subplot(222); imshow(img_417); title('��ȡ����pdf417');
img_show = img_in;
img_show(map_intervel(1),:,1) = 0;
img_show(map_intervel(1),:,2) = 255;
img_show(map_intervel(2),:,1) = 0;
img_show(map_intervel(2),:,2) = 255;

img_show(:,map_intervel(3),1) = 0;
img_show(:,map_intervel(3),2) = 255;
img_show(:,map_intervel(4),1) = 0;
img_show(:,map_intervel(4),2) = 255;
subplot(223); image(img_show);

%------------------------------------------------------------------------------------%
%% sec-4-1
%�õ���ά����ĸ�����
[lines, points] = imgHoughLine(img_4171);

%˫���Ա任
img_bilinear = imgBilinear(img_4171,points);

%��ֵ
img_interpolation = imgDilate(img_bilinear,structor3);
img_interpolation = imgErode(img_interpolation,structor3);

%%
%��ʾ���
figure('Name','main');
subplot(223);imshow(img_bilinear); title('������Ķ�ά��');
subplot(224);imshow(img_interpolation); title('��ֵ��Ķ�ά��');