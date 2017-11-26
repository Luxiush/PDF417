%二维码的定位和裁剪
%% sec-1-1 读取图像，并进行二值化
%img_in = imread('../img/7.png'); 
img_in = imread('../img/test-1.png'); 
img_gray = rgb2gray(img_in);

img_bin = ostu(img_gray);

%因为之前设计的膨胀、腐蚀操作都默认1为前景色，而二维码的前景色是0，所以先进行反转。
img_bin = ~logical(img_bin); 

%% sec-1-2 对图像进行膨胀,增强连通性
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

%% sec-1-3 对边界进行膨胀，重构
[rows,cols]=size(img_dilate);
%marker初始化为原图的边界
marker = zeros(rows,cols);
marker(1,:)=img_dilate(1,:);
marker(rows,:)=img_dilate(rows,:);
marker(:,1)=img_dilate(:,1);
marker(:,cols)=img_dilate(:,cols);

structor_size = 5;
reconstruct_structor = ones(structor_size);%结构元素
%膨胀次数 = 最后的边界宽度(设为图像宽度的50%)/每次膨胀的点数(floor(structor_size/2));
reconstruct_times = ceil((0.5*cols)/floor(structor_size/2));%边界重构次数
for i = 1:reconstruct_times
    marker = imgDilate(marker,reconstruct_structor);%对边界进行膨胀
    marker = marker&img_dilate;%膨胀后与原图取交集 
end

%去除与边界相连的连通域
img_connect = img_dilate - marker;

%%
figure; 
subplot(221); imshow(img_bin);title('反转后的二值图像');
subplot(222); imshow(img_dilate); title([num2str(dilate_times),'次膨胀腐蚀后的图像']);
subplot(223); imshow(marker);title(['边界膨胀',num2str(reconstruct_times),'次后']);
subplot(224); imshow(img_connect);title('去掉与边界相连的连通域后');

%------------------------------------------------------------------------------------%
%% sec-2-1  建立查找表，去除小面积连通域
[img_label,num_label] = bwlabel(img_connect, 8);

%统计每个联通域的大小
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

%大连通域和小连通域的阈值
connected_threshold = max(connected_size)/2;

%去掉小面积连通域
img_label2 = img_label;
for r = 1:rows
   for c = 1:cols
       num = img_label2(r,c);%当前点所在连通域的编号
       if(num > 0 && connected_size(num) < connected_threshold)
           img_label2(r,c) = 0;
       end
   end
end

%%
figure; 
subplot(221); image(img_label/num_label*255, 'CDataMapping','scaled'); colorbar; title('联通图');
subplot(222); plot(connected_size); title(['每个连通域的大小（共',num2str(num_label),'个）']);
subplot(223); image(img_label2, 'CDataMapping','scaled'); colorbar; title('去掉小面积连通域后');

%% sec-2-2 为了避免投影定位截取到的图像不完整，先对图像进行膨胀拓展二维码边界
img_label2 = imgDilate(img_label2,reconstruct_structor);

%------------------------------------------------------------------------------------%
%% sec-3-1  投影定位,截取二维码
    %投影定位
img_417 = logical(img_label2);
map_row = zeros(1,rows); %前景像素在每一行上的投影
map_col = zeros(1,cols); %在每一列上的投影

for r = 1:rows
    map_row(r) = sum(img_417(r,:));
    if(r>1)%平滑处理 S(k) = 0.7S(k) + 0.3S(k+1)
       map_row(r-1) = 0.7*map_row(r-1)+0.3*map_row(r); 
    end
end
for c = 1:cols
   map_col(c) = sum(img_417(:,c)); 
    if(c>1)%平滑处理 S(k) = 0.7S(k) + 0.3S(k+1)
       map_col(c-1) = 0.7*map_col(c-1)+0.3*map_col(c); 
    end   
end

%map_row_mean = mean(map_row);
%map_col_mean = mean(map_col);
map_row_mean = 0;
map_col_mean = 0;
map_intervel = [0,0,0,0];%行区间和列区间
for r = 1:rows
   if(map_row(r)>map_row_mean)%第一个大于阈值的行数作为区间起点
       map_intervel(1) = r; break;
   end
end
for r = rows:-1:1
   if(map_row(r)>map_row_mean)%第一个大于阈值的行数作为区间终点
       map_intervel(2) = r; break;
   end
end

for c = 1:cols
   if(map_col(c)>map_col_mean)%第一个大于阈值的列数作为区间起点
       map_intervel(3) = c; break;
   end
end
for c = cols:-1:1
   if(map_col(c)>map_col_mean)%第一个大于阈值的列数作为区间终点
       map_intervel(4) = c; break;
   end
end

img_4170 = img_label2&img_bin;
    %截取
img_417 = img_4170(map_intervel(1):map_intervel(2),map_intervel(3):map_intervel(4));

    %为了便于后续处理将图片进行拓展
    extend_size = 60;
    [rows,cols] = size(img_417);
    img_4171 = zeros(rows+extend_size*2,cols+extend_size*2);
    img_4171(1+extend_size:rows+extend_size,1+extend_size:cols+extend_size) = img_417;

%%
figure;
subplot(221); plot(map_row, 'r-.'); 
hold on;      plot(map_col, 'g');
legend('行上的投影','列上的投影');
hold off;
subplot(222); imshow(img_417); title('截取到的pdf417');
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
%得到二维码的四个顶点
[lines, points] = imgHoughLine(img_4171);

%双线性变换
img_bilinear = imgBilinear(img_4171,points);

%插值
img_interpolation = imgDilate(img_bilinear,structor3);
img_interpolation = imgErode(img_interpolation,structor3);

%%
%显示结果
figure('Name','main');
subplot(223);imshow(img_bilinear); title('矫正后的二维码');
subplot(224);imshow(img_interpolation); title('插值后的二维码');