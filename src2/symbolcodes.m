%% 码字提取
img_in = imread('../img/week12test.bmp');
img_in = logical(img_in);
img_edge = edge(img_in,'Sobel');

show_details = 1;

%figure('Name','symcodes'); imshow(img_in);
%figure('Name','symcodes'); imshow(img_edge);

%%
%prewitt算子
prewittx = [-1,-1,-1;0,0,0;1,1,1];
prewitty = [-1,0,1;-1,0,1;-1,0,1];

[rows, cols] = size(img_in);
img_ext = double(zeros(rows+2,cols+2));
img_ext(2:rows+1,2:cols+1) = img_in;

%水平边缘
img_edgex = zeros(rows+2,cols+2);
%竖直边缘
img_edgey = zeros(rows+2,cols+2);

for r = 2:rows+1
   for c = 2:cols+1
       img_edgex(r,c) = abs(sum(sum(img_ext(r-1:r+1,c-1:c+1).*prewittx)));
       img_edgey(r,c) = abs(sum(sum(img_ext(r-1:r+1,c-1:c+1).*prewitty)));
   end
end
img_edgex = logical(img_edgex(2:rows+1,2:cols+1));
img_edgey = logical(img_edgey(2:rows+1,2:cols+1));

%水平投影
projectionx = zeros(rows,1);
for i = 1:rows
   projectionx(i) = sum(img_edgex(i,:),2); 
end

if(show_details == 1)
%    figure; image(img_edgex,'CDataMapping','scaled'); colorbar; title('水平边缘');
%    figure; image(img_edgey,'CDataMapping','scaled'); colorbar; title('竖直边缘');
    figure; image(img_edgex+img_edgey,'CDataMapping','scaled'); colorbar; title('水平边缘和竖直边缘');
    figure; plot(projectionx); title('水平边缘在每一行上的投影'); 
end

%%
%记录峰值
lines = zeros(rows,1);
j = 1;
for i = 1+2:rows-2
    if(projectionx(i)>0 && projectionx(i) == max(projectionx(i-2:i+2)))
        lines(j) = i; j=j+1;
        projectionx(i-2:i+2) = [0,0,projectionx(i),0,0];%削峰，由于之前得到边缘有是双重的(0110)，暂时没想到更好的办法
    end
end
j = j-1;
lines = lines(1:j);

%计算每层的中心
layers_num = j+1;%总层数
layers = zeros(layers_num);
layers(1) = round((1+lines(1))/2);%第一层的中心
layers(layers_num) = round((rows+lines(j))/2);%最后一层
for i = 2:layers_num-1
    layers(i) = round((lines(i-1)+lines(i))/2);
end

if(show_details == 1)
    figure; imshow(img_in); title('每层的中心'); hold on;
    for i = 1:layers_num
       line([1,cols],[layers(i),layers(i)],'Color',[1,0,0]);
    end
    hold off;
end

%%
%提取码字
code = zeros(layers_num,cols);
for l = 1:layers_num
   j = 1; 
   pre = 1; %记录前一个边缘点的坐标
   for c = 1:cols
       if(img_edgey(layers(l),c) == 1)
           code(l,j) = c-pre; j = j+1;
           pre = c;
           img_edgey(layers(l),c+1) = 0;%因为之前得到边缘有是双重的(0110)
       end
   end
   code(l,j) = cols-pre; %最后一个
end
code = code(:,1:j);

%% 
%计算模块大小
aunit = round((sum(code(:,1))/layers_num)/8);%一个模块的长度
code = round(code/aunit);%每个条或空的模块数,得到符号字符

%去除左右起止符和左右行指示符号字符
code = code(:,17:j-17);

[code_size.rows, code_size.cols] = size(code);
decode = zeros(code_size.rows,floor(code_size.cols/8));

load symcodes.mat -ascii;

%解码码字转换
for r = 1:code_size.rows
   cluster = mod(r-1,3)+1; %簇号 0,3,6  ==> 1,2,3 
   temp = 0;
   for c = 1:code_size.cols
      temp = temp*10 + code(r,c);%计算符号字符
      if(mod(c,8)==0)
          for i = 1:929 %通过查找表，转换为码字
             if(symcodes(cluster,i) == temp)
                 decode(r,floor(c/8)) = i-1; break;
             end
          end
          temp = 0;
      end
   end
end






