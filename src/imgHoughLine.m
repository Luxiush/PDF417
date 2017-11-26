%houghֱ�߱任
%����img_bin Ϊ��ת��Ķ�ֵͼ��, 
%����lines����õ��������߽�ֱ�ߵĲ���
%line����߽�ֱ�� lines(:,1)Ϊ��img_hough�ж�Ӧ���ֵ; lines(:,2)Ϊrho; lines(:,3)Ϊtheta
%points����ֱ�ߵĽ���,��һά��ԭ��ľ��룬�ڶ�άx���꣬����άy����
function [lines, points] = imgHoughLine(img_bin)
    show_detail = 1; %�Ƿ���ʾ�м����
%% sec---1
    %��ͼ�������
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

    %��ȡ��Ե
    structor3 = ones(3);
    img_edge = imgDilate(img_closed,structor3)-img_closed;

%% disp   
    if(show_detail == 1)
%        figure('Name','imgHhoughLine');
%        subplot(211); imshow(img_bin); title('ԭͼ');
%        subplot(212); imshow(img_closed); title('�����');
        figure('Name','imgHhoughLine'); imshow(img_edge); title('��Ե');
    end
    
%% sec---2 
    %Houghֱ�߱任
    %input: img_edge
    %output: hough[rho][theta]
    img_edge = logical(img_edge);

    %�����ۼӾ���
    [rows,cols] = size(img_edge);
    rho_max = ceil(sqrt(cols*cols+rows*rows));
    theta_max = 180; 
    img_hough = zeros(2*rho_max+1,theta_max); % -rho_max < rho < rho_max

    %����ͼ��
    for y = 1:rows
       for x = 1:cols
          if(img_edge(y,x) > 0) 
              for theta = 1:180 %��  %sin(x) x���Ի���Ϊ��λ ����������
                 rho = ceil(y*sin(theta*pi/180)+x*cos(theta*pi/180))+rho_max; %��Ϊ��������Ϊ����������Ҫ��rho����ƽ��
                 img_hough(rho,theta) = img_hough(rho,theta) + 1;
              end
          end
       end
    end

    %��չ
    ext_size = 10;
    [rows,cols] = size(img_hough);
%    half_rows=round(rows/2);
    half_cols=round(cols/2);
    img_hough_ext = zeros(rows+2*ext_size,cols+2*ext_size);
    img_hough_ext(1+ext_size:rows+ext_size,1+ext_size:cols+ext_size) = img_hough;
 
    %�ҳ���ֵ��ߵ�4��ֱ��
    lines = zeros(4,3); %lines(:,1)Ϊ��img_hough�ж�Ӧ���ֵ; lines(:,2)Ϊrho; lines(:,3)Ϊtheta
    mask = zeros(2*ext_size);
    theta_a = 0; theta_b = 0; %������theta��Χ
    for i = 1:4
        if(i<=2) %���˵����lines(1)��lines(2)��ƽ�е�
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
    % Ѱ��ֱ�߽���
    %                       |cos(theta1) cos(theta2)|
    % [rho1 rho2] = [x y] * |                       |
    %                       |sin(theta1) sin(theta2)|
    %                                 ��M ����
   
    [rows,cols] = size(img_bin);
    %points(:,1) |points(:,2) |points(:,3) |points(:,4) 
    %��ԭ��ľ��� |x����       |y����        |ָ��������
    points = zeros(4,4);
    p = 1;
    for i = 1:3
       for j = i+1:4
           if(abs(lines(i,3)-lines(j,3))>20)%����ֱ�߲�ƽ�� 20Ϊ������ֵ��
               rho1 = lines(i,2)-rho_max; %��Ϊ��������Ϊ�����Զ�rho����ƽ�ƣ�ʵ��ʹ��ʱ����ƽ�ƻ�ȥ
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
        figure('Name','imgHhoughLine'); mesh(img_hough);  title('ֱ�߱任��');
        figure('Name','imgHhoughLine'); mesh(img_hough_ext); title('�����');
        figure('Name','imgHhoughLine'); 
        imshow(img_bin); hold on;
        plot(points(:,2),points(:,3),'Marker','O','Color','red');
        hold off;
        title('�ҵ��ı߽�ֱ�ߵĽ���');
    end
end











