%% ������ȡ
img_in = imread('../img/week12test.bmp');
img_in = logical(img_in);
img_edge = edge(img_in,'Sobel');

show_details = 1;

%figure('Name','symcodes'); imshow(img_in);
%figure('Name','symcodes'); imshow(img_edge);

%%
%prewitt����
prewittx = [-1,-1,-1;0,0,0;1,1,1];
prewitty = [-1,0,1;-1,0,1;-1,0,1];

[rows, cols] = size(img_in);
img_ext = double(zeros(rows+2,cols+2));
img_ext(2:rows+1,2:cols+1) = img_in;

%ˮƽ��Ե
img_edgex = zeros(rows+2,cols+2);
%��ֱ��Ե
img_edgey = zeros(rows+2,cols+2);

for r = 2:rows+1
   for c = 2:cols+1
       img_edgex(r,c) = abs(sum(sum(img_ext(r-1:r+1,c-1:c+1).*prewittx)));
       img_edgey(r,c) = abs(sum(sum(img_ext(r-1:r+1,c-1:c+1).*prewitty)));
   end
end
img_edgex = logical(img_edgex(2:rows+1,2:cols+1));
img_edgey = logical(img_edgey(2:rows+1,2:cols+1));

%ˮƽͶӰ
projectionx = zeros(rows,1);
for i = 1:rows
   projectionx(i) = sum(img_edgex(i,:),2); 
end

if(show_details == 1)
%    figure; image(img_edgex,'CDataMapping','scaled'); colorbar; title('ˮƽ��Ե');
%    figure; image(img_edgey,'CDataMapping','scaled'); colorbar; title('��ֱ��Ե');
    figure; image(img_edgex+img_edgey,'CDataMapping','scaled'); colorbar; title('ˮƽ��Ե����ֱ��Ե');
    figure; plot(projectionx); title('ˮƽ��Ե��ÿһ���ϵ�ͶӰ'); 
end

%%
%��¼��ֵ
lines = zeros(rows,1);
j = 1;
for i = 1+2:rows-2
    if(projectionx(i)>0 && projectionx(i) == max(projectionx(i-2:i+2)))
        lines(j) = i; j=j+1;
        projectionx(i-2:i+2) = [0,0,projectionx(i),0,0];%���壬����֮ǰ�õ���Ե����˫�ص�(0110)����ʱû�뵽���õİ취
    end
end
j = j-1;
lines = lines(1:j);

%����ÿ�������
layers_num = j+1;%�ܲ���
layers = zeros(layers_num);
layers(1) = round((1+lines(1))/2);%��һ�������
layers(layers_num) = round((rows+lines(j))/2);%���һ��
for i = 2:layers_num-1
    layers(i) = round((lines(i-1)+lines(i))/2);
end

if(show_details == 1)
    figure; imshow(img_in); title('ÿ�������'); hold on;
    for i = 1:layers_num
       line([1,cols],[layers(i),layers(i)],'Color',[1,0,0]);
    end
    hold off;
end

%%
%��ȡ����
code = zeros(layers_num,cols);
for l = 1:layers_num
   j = 1; 
   pre = 1; %��¼ǰһ����Ե�������
   for c = 1:cols
       if(img_edgey(layers(l),c) == 1)
           code(l,j) = c-pre; j = j+1;
           pre = c;
           img_edgey(layers(l),c+1) = 0;%��Ϊ֮ǰ�õ���Ե����˫�ص�(0110)
       end
   end
   code(l,j) = cols-pre; %���һ��
end
code = code(:,1:j);

%% 
%����ģ���С
aunit = round((sum(code(:,1))/layers_num)/8);%һ��ģ��ĳ���
code = round(code/aunit);%ÿ������յ�ģ����,�õ������ַ�

%ȥ��������ֹ����������ָʾ�����ַ�
code = code(:,17:j-17);

[code_size.rows, code_size.cols] = size(code);
decode = zeros(code_size.rows,floor(code_size.cols/8));

load symcodes.mat -ascii;

%��������ת��
for r = 1:code_size.rows
   cluster = mod(r-1,3)+1; %�غ� 0,3,6  ==> 1,2,3 
   temp = 0;
   for c = 1:code_size.cols
      temp = temp*10 + code(r,c);%��������ַ�
      if(mod(c,8)==0)
          for i = 1:929 %ͨ�����ұ�ת��Ϊ����
             if(symcodes(cluster,i) == temp)
                 decode(r,floor(c/8)) = i-1; break;
             end
          end
          temp = 0;
      end
   end
end






