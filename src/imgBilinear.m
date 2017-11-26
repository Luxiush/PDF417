%˫���Ա任
%                     i
% x    c1 c2 c3 c4    j
%    =             *  i*j
% y    c5 c6 c7 c8    1
% ((i,j)Ϊԭͼ��ĵ㣬(x,y)Ϊ��ͼ�ĵ�)
% --> x = c1*i + c2*j + c3*i*j + c4
%     y = c5*i + c6*j + c7*i*j + c8

%�����ֵͼ��Ͷ�ά����ĸ��������꣬���˫���Ա任���ͼ��δ��ֵ
%points ��һ�д浽ԭ��ľ��룬�ڶ����зֱ��x��y���꣬
%       �����б�������ţ�ͨ����ſ���ȷ�����������Թ�ϵ��
%       ���1��4���ڶԽ�λ�ã�2��3�Խǣ�����imgHough�н���ֱ�ߵ��󷨾�����
function img_bilinear = imgBilinear(img_bin, points)
%   img_bin = img_417;
    show_detail = 1;%��Ϊ1ʱ��ʾ�м���
    
    P1 = sortrows(points,4);%����������򣬱���Ѱ����Ӧ��ŵĵ�
    %P(1)Ϊ��ԭ�������С�ĵ�
    P =sortrows(points,1);
    %P(4)��P(1)�Խ�
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
    
    
    %P(2)��P(1)�ľ����P(3)��P(1)�ľ���С
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
    height = round(sqrt((Pa(1,1)-Pa(2,1))^2+(Pa(1,2)-Pa(2,2))^2)); %�߶� = |Pa1 Pa2|
    width = round(sqrt((Pa(1,1)-Pa(3,1))^2+(Pa(1,2)-Pa(3,2))^2));  %��� = |Pa1 Pa3|

    O = [80;80]; %��ͼ��ԭ��
    Pb = zeros(2,4); %��ͼ����
    Pb(:,1) = O;
    Pb(:,2) = O + [0;height];
    Pb(:,3) = O + [width;0];
    Pb(:,4) = O + [width;height];

 
%��任����
% x = c1*i + c2*j + c3*i*j + c4
    M = [Pa(1,1),Pa(2,1),Pa(3,1),Pa(4,1);
         Pa(1,2),Pa(2,2),Pa(3,2),Pa(4,2);
         [Pa(1,1),Pa(2,1),Pa(3,1),Pa(4,1)].*[Pa(1,2),Pa(2,2),Pa(3,2),Pa(4,2)];
         [1,1,1,1]];
    C = Pb/M; %�任����

%%
%��ͼ����б任
    [rows,cols] = size(img_bin);
    map = zeros(rows*cols,5); %��һ��ά��ԭ�������꣬����ά�������꣬����ά������ֵ
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
%��ʾ���
    if(show_detail == 1)
        figure;
        plot(map(:,1),map(:,2),'.','Color','red');
        hold on;
        plot(map(:,3),map(:,4),'.','Color','green');
        plot(Pa(:,1),Pa(:,2),'Marker','o','Color','blue');
        plot(Pb(1,:),Pb(2,:),'Marker','*','Color','black');
        hold off;
        legend('����ǰ','������','����ǰ','������');
    end
end
