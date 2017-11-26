%二维码的定位和裁剪
%在main2的基础上做一些优化：
%1。通过查找表的方法去除与边界相连的连通域
%2。截取图像改为
%    将去除小面积连通域后剩下的部分
%    先与原图做与操作得到二维码去掉背景后
%    再通过投影定位确定二维码所在区间
%    再进行裁剪得到干净的二维码

%输入二值化后的图像，输出裁剪到的二维码
function img_417 = imgDetect(img_bin) 
    show_detail = 1;%为1时显示中间结果
%% 对图像进行膨胀,增强连通性
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

    %% 获取边界
    [rows,cols]=size(img_dilate);
    %marker初始化为原图的边界
    marker = uint8(zeros(rows,cols));
    marker(1:2,:)=img_dilate(1:2,:);
    marker(rows-1:rows,:)=img_dilate(rows-1:rows,:);
    marker(:,1:2)=img_dilate(:,1:2);
    marker(:,cols-1:cols)=img_dilate(:,cols-1:cols);

    %% 建立查找表
    [img_label,num_label] = bwlabel(img_dilate, 8);

    %% 通过查找表去除与边界相连的连通域
    img_label2 = img_label;
    for r_m = 1:rows  
    for c_m = 1:cols   %遍历原图边界（marker）
       if(marker(r_m,c_m)==1) %对于边界上的每个前景像素，
          num = img_label(r_m,c_m); %找到它所属于的连通域
          if(num > 0) 
              for r = 1:rows
              for c = 1:cols
				%将连通图（img_label）中属于该连通域的点都抹掉
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
        subplot(121); imshow(img_bin);title('输入图像');
        subplot(122); imshow(img_dilate); title([num2str(dilate_times),'次膨胀腐蚀后的图像']);
        figure('Name','imgDetecet'); 
        subplot(221); image(img_label/num_label*255, 'CDataMapping','scaled'); colorbar; title('联通图');
        subplot(222); image(img_label2/num_label*255, 'CDataMapping','scaled'); colorbar; title('去掉与边界相连的连通域后');
    end

    %% 通过查找表去除小面积连通域

    %统计每个联通域的大小
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

    %大连通域和小连通域的阈值
    connected_threshold = max(connected_size)/2;

    %去掉小面积连通域
    img_label3 = img_label2;
    for r = 1:rows
       for c = 1:cols
           num = img_label2(r,c);%当前点所在连通域的编号
           if(num > 0 && connected_size(num) < connected_threshold)
               img_label3(r,c) = 0;
           end
       end
    end

    if(show_detail==1)
       subplot(223);image(img_label3/num_label*255, 'CDataMapping','scaled'); colorbar;  title('去掉小面积连通域后');
       subplot(224); plot(connected_size); title(['每个连通域的大小（共',num2str(num_label),'个 ,阈值:',num2str(connected_threshold),'）']);
    end

    %% 投影定位,截取二维码
    
    %为了避免投影定位截取到的图像不完整，先对图像进行膨胀拓展二维码边界
    img_label_extend = logical(img_label3);
    img_label_extend = imgDilate(img_label_extend,ones(5,5));

    %投影定位
    map_row = zeros(1,rows); %前景像素在每一行上的投影
    map_col = zeros(1,cols); %在每一列上的投影

    for r = 1:rows
        map_row(r) = sum(img_label_extend(r,:));
        if(r>1)%平滑处理 S(k) = 0.7S(k) + 0.3S(k+1)
           map_row(r-1) = 0.7*map_row(r-1)+0.3*map_row(r); 
        end
    end
    for c = 1:cols
       map_col(c) = sum(img_label_extend(:,c)); 
        if(c>1)%平滑处理 S(k) = 0.7S(k) + 0.3S(k+1)
           map_col(c-1) = 0.7*map_col(c-1)+0.3*map_col(c); 
        end   
    end

    %map_row_mean = mean(map_row);
    %map_col_mean = mean(map_col);
    map_row_mean = 0;
    map_col_mean = 0;
    map_interval = [0,0,0,0];%行区间和列区间
    for r = 1:rows
       if(map_row(r)>map_row_mean)%第一个大于阈值的行数作为区间起点
           map_interval(1) = r; break;
       end
    end
    for r = rows:-1:1
       if(map_row(r)>map_row_mean)%第一个大于阈值的行数作为区间终点
           map_interval(2) = r; break;
       end
    end

    for c = 1:cols
       if(map_col(c)>map_col_mean)%第一个大于阈值的列数作为区间起点
           map_interval(3) = c; break;
       end
    end
    for c = cols:-1:1
       if(map_col(c)>map_col_mean)%第一个大于阈值的列数作为区间终点
           map_interval(4) = c; break;
       end
    end

    %去掉背景
    img_417_0 = img_bin & img_label3;   
    %截取
    img_417_1 = logical(img_417_0(map_interval(1):map_interval(2),map_interval(3):map_interval(4)));
    
    %为了便于后续处理将图片进行拓展
    [rows,cols] = size(img_417_1);
    extend_size = 30;
    img_417 = zeros(rows+extend_size*2,cols+extend_size*2);
    img_417(1+extend_size:rows+extend_size,1+extend_size:cols+extend_size) = img_417_1;

    %%
    if(show_detail ==1)
        figure('Name','imgDetecet');
        subplot(221); plot(map_row, 'r-.'); 
        hold on;      plot(map_col, 'g');
        legend('行上的投影','列上的投影');
        hold off;
        subplot(222); imshow(img_417_1); title('截取到的pdf417');

        subplot(223); imshow(img_bin); hold on;
        plot([1,cols],[map_interval(1),map_interval(1)],'r');
        plot([1,cols],[map_interval(2),map_interval(2)],'r');
        plot([map_interval(3),map_interval(3)],[1,rows],'r');
        plot([map_interval(4),map_interval(4)],[1,rows],'r');
        hold off; title('二维码所在区间');
    end
end
