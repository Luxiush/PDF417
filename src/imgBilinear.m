%双线性变换
%                     i
% x    c1 c2 c3 c4    j
%    =             *  i*j
% y    c5 c6 c7 c8    1
% ((i,j)为原图像的点，(x,y)为新图的点)
% --> x = c1*i + c2*j + c3*i*j + c4
%     y = c5*i + c6*j + c7*i*j + c8

%输入二值图像和二维码的四个顶点坐标，输出双线性变换后的图像，未插值
%points 第一列存到原点的距离，第二三列分别存x和y坐标，
%       第四列保存点的序号（通过序号可以确定各个点的相对关系）
%       序号1和4处于对角位置，2和3对角，（由imgHough中交点直线的求法决定）
function img_bilinear = imgBilinear(img_bin, points)
%   img_bin = img_417;
    show_detail = 1;%置为1时显示中间结果
    
    P1 = sortrows(points,4);%根据序号排序，便于寻找相应序号的点
    %P(1)为到原点距离最小的点
    P =sortrows(points,1);
    %P(4)与P(1)对角
    if(P(1,4)==1) 
        P(2,:) = P1(2,:);
        P(3,:) = P1(3,:);
        P(4,:) = P1(4,:); 
    end
    if(P(1,4)==2)
        P(2,:) = P1(1,:);
        P(3,:) = P1(4,:);
        P(4,:) = P1(3,:); 
    end
    if(P(1,4)==3)
        P(2,:) = P1(1,:);
        P(3,:) = P1(4,:);
        P(4,:) = P1(1,:); 
    end
    if(P(1,4)==4) 
        P(2,:) = P1(2,:);
        P(3,:) = P1(3,:);
        P(4,:) = P1(1,:); 
    end
    
    
    %P(2)到P(1)的距离比P(3)到P(1)的距离小
    len_12 = (P(1,2)-P(2,2))^2+(P(1,3)-P(2,3))^2; %|P1 P2|
    len_13 = (P(1,2)-P(3,2))^2+(P(1,3)-P(3,3))^2; %|P1 P3|
    temp = zeros(1,4);
    if(len_12>len_13)
        temp = P(2,:);
        P(2,:) = P(3,:);
        P(3,:) = temp;
    end
    
    %%
    Pa = P(:,2:3);
    height = round(sqrt((Pa(1,1)-Pa(2,1))^2+(Pa(1,2)-Pa(2,2))^2)); %高度 = |Pa1 Pa2|
    width = round(sqrt((Pa(1,1)-Pa(3,1))^2+(Pa(1,2)-Pa(3,2))^2));  %宽度 = |Pa1 Pa3|

    O = [80;80]; %新图的原点
    Pb = zeros(2,4); %新图坐标
    Pb(:,1) = O;
    Pb(:,2) = O + [0;height];
    Pb(:,3) = O + [width;0];
    Pb(:,4) = O + [width;height];

 
%求变换矩阵
% x = c1*i + c2*j + c3*i*j + c4
    M = [Pa(1,1),Pa(2,1),Pa(3,1),Pa(4,1);
         Pa(1,2),Pa(2,2),Pa(3,2),Pa(4,2);
         [Pa(1,1),Pa(2,1),Pa(3,1),Pa(4,1)].*[Pa(1,2),Pa(2,2),Pa(3,2),Pa(4,2)];
         [1,1,1,1]];
    C = Pb/M; %变换矩阵

%%
%对图像进行变换
    [rows,cols] = size(img_bin);
    map = zeros(rows*cols,5); %第一二维存原来的坐标，三四维存新坐标，第五维存像素值
    img_bilinear = uint8(zeros(height+2*O(1),width+2*O(2)));
    for y = 1:rows
       for x = 1:cols
          if(img_bin(y,x) > 0)
             xy = round(C*[x;y;x*y;1]); 
             img_bilinear(xy(2),xy(1)) = 255;
             
              if(show_detail == 1)
                 k = cols*(y-1)+x;
                 map(k,:) = [x,y,xy(1),xy(2),img_bin(y,x)];
              end
          end
       end
    end

%%
%显示结果
    if(show_detail == 1)
        figure;
        plot(map(:,1),map(:,2),'.','Color','red');
        hold on;
        plot(map(:,3),map(:,4),'.','Color','green');
        plot(Pa(:,1),Pa(:,2),'Marker','o','Color','blue');
        plot(Pb(1,:),Pb(2,:),'Marker','*','Color','black');
        hold off;
        legend('矫正前','矫正后','矫正前','矫正后');
    end
end
