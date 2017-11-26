A = [0,0,0,0,0,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,0,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;255,255,255,255,0,0,255,255,0,255;255,255,255,255,0,0,0,0,0,255;255,255,255,255,0,0,0,0,0,255];
L = logical(A);
S = [0,0,0;
     1,1,1;
     0,0,0];
S = logical(S); 
 
out = imgDilate(L,S);

subplot(141);
imshow(L);
subplot(142);
imshow(S);
subplot(143);
imshow(out);
subplot(144);
imshow(imdilate(L,S));

%%
%形态学重构
%Reference： http://www.mmorph.com/mmtutor1.0/html/mmtutor/mm060reconstruction.html
img = imread('../img/blob.png'); %原图作为掩膜（mask）
img = rgb2gray(img);
img = logical(ostu(img));
[row,col]=size(img);
%marker初始化为原图的边界
marker = zeros(row,col);
marker(1,:)=img(1,:);
marker(row,:)=img(row,:);
marker(:,1)=img(:,1);
marker(:,col)=img(:,col);

imshow(marker);title('初始边界');

structor = ones(3);%结构元素

for i = 1:30
    marker = imgDilate(marker,structor);%对边界进行膨胀
    marker = marker&img;%膨胀后与原图取交集 
end

figure;
subplot(121);
imshow(img);title('原图');
subplot(122);
imshow(marker);title('边界膨胀30次后');
