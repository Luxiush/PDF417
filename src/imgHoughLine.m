%hough直线变换
%输入img_bin 为反转后的二值图像, 
%返回lines保存得到的四条边界直线的参数
%line保存边界直线 lines(:,1)为在img_hough中对应点的值; lines(:,2)为rho; lines(:,3)为theta
%points保存直线的交点,第一维到原点的距离，第二维x坐标，第三维y坐标
function [lines, points] = imgHoughLine(img_bin)
    show_detail = 1; %是否显示中间过程
%% sec---1
    %将图像揉成团
%{
    structor_erode2 = [0,1,0;
                       1,1,1;
                       0,1,0];
    structor_dilate2 = ones(9);
%}    
    stru_disk = struDiskGenerator(20);
    img_closed = img_bin;
    for i = 1:2
        img_closed = imgDilate(img_closed,stru_disk);
        img_closed = imgErode(img_closed,stru_disk);
    end

    %提取边缘
    structor3 = ones(3);
    img_edge = imgDilate(img_closed,structor3)-img_closed;

%% disp   
    if(show_detail == 1)
%        figure('Name','imgHhoughLine');
%        subplot(211); imshow(img_bin); title('原图');
%        subplot(212); imshow(img_closed); title('揉成团');
        figure('Name','imgHhoughLine'); imshow(img_edge); title('边缘');
    end
    
%% sec---2 
    %Hough直线变换
    %input: img_edge
    %output: hough[rho][theta]
    img_edge = logical(img_edge);

    %建立累加矩阵
    [rows,cols] = size(img_edge);
    rho_max = ceil(sqrt(cols*cols+rows*rows));
    theta_max = 180; 
    img_hough = zeros(2*rho_max+1,theta_max); % -rho_max < rho < rho_max

    %遍历图像
    for y = 1:rows
       for x = 1:cols
          if(img_edge(y,x) > 0) 
              for theta = 1:180 %度  %sin(x) x是以弧度为单位 ！！！！！
                 rho = ceil(y*sin(theta*pi/180)+x*cos(theta*pi/180))+rho_max; %因为索引必须为正，所以需要对rho进行平移
                 img_hough(rho,theta) = img_hough(rho,theta) + 1;
              end
          end
       end
    end

    %拓展
    ext_size = 10;
    [rows,cols] = size(img_hough);
%    half_rows=round(rows/2);
    half_cols=round(cols/2);
    img_hough_ext = zeros(rows+2*ext_size,cols+2*ext_size);
    img_hough_ext(1+ext_size:rows+ext_size,1+ext_size:cols+ext_size) = img_hough;
 
    %找出峰值最高的4条直线
    lines = zeros(4,3); %lines(:,1)为在img_hough中对应点的值; lines(:,2)为rho; lines(:,3)为theta
    mask = zeros(2*ext_size);
    theta_a = 0; theta_b = 0; %搜索的theta范围
    for i = 1:4
        if(i<=2) %间接说明了lines(1)和lines(2)是平行的
            theta_a = 1+ext_size; theta_b = 90+ext_size; 
        end
        if(i>=3)
            theta_a = 91+ext_size; theta_b = 180+ext_size;
        end
        peak = max(max(img_hough_ext(:,theta_a:theta_b))); 
        
        [rows,cols] = size(img_hough_ext);
        for rh = 1:rows
           for th = theta_a:theta_b
              if(img_hough_ext(rh,th) == peak), break; end
           end
           if(img_hough_ext(rh,th) == peak), break; end
        end
        rh = rh-ext_size;
        th = th-ext_size;
        lines(i,:) = [peak,rh,th]; 
        img_hough_ext(rh:rh+2*ext_size-1,th:th+2*ext_size-1) = mask;
    end
        
%% cross points
    % 寻找直线交点
    %                       |cos(theta1) cos(theta2)|
    % [rho1 rho2] = [x y] * |                       |
    %                       |sin(theta1) sin(theta2)|
    %                                 （M 矩阵）
   
    [rows,cols] = size(img_bin);
    %points(:,1) |points(:,2) |points(:,3) |points(:,4) 
    %到原点的距离 |x坐标       |y坐标        |指明点的序号
    points = zeros(4,4);
    p = 1;
    for i = 1:3
       for j = i+1:4
           if(abs(lines(i,3)-lines(j,3))>20)%两条直线不平行 20为“经验值”
               rho1 = lines(i,2)-rho_max; %因为索引必须为正所以对rho进行平移，实际使用时将其平移回去
               rho2 = lines(j,2)-rho_max;
               Rho = [rho1,rho2];
               theta1 = lines(i,3)*pi/180;
               theta2 = lines(j,3)*pi/180;
               M = [cos(theta1),cos(theta2);sin(theta1),sin(theta2)];
               xy = Rho/M;
               if(0<xy(1)&&xy(1)<=cols && 0<xy(2)&&xy(2)<=rows)
                   points(p,:) = [sqrt(xy(1)^2+xy(2)^2),round(xy(1)),round(xy(2)),p];
                   p = p+1;
               end
           end
       end
    end
    
%% disp
    if(show_detail == 1)
        figure('Name','imgHhoughLine'); mesh(img_hough);  title('直线变换后');
        figure('Name','imgHhoughLine'); mesh(img_hough_ext); title('削峰后');
        figure('Name','imgHhoughLine'); 
        imshow(img_bin); hold on;
        plot(points(:,2),points(:,3),'Marker','O','Color','red');
        hold off;
        title('找到的边界直线的交点');
    end
end











