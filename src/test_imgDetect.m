%在main2的基础上做一些优化：
%1。通过查找表的方法去除与边界相连的连通域
%2。截取图像改为将去除小面积连通域后剩下的部分
%    先与原图做与操作得到二维码去掉背景后
%    再通过投影定位确定二维码所在区间
%    再进行裁剪得到干净的二维码

%img_rgb = imread('../img/7.png'); 
%img_rgb = imread('../img/test-1.png'); 
img_rgb = imread('../img_test/lv3.jpg'); 
%img_rgb = imread('../img_test/lv6.jpg'); 

img_gray = rgb2gray(img_rgb);

img_bin = ostu(img_gray);
%因为之前设计的膨胀、腐蚀操作都默认1为前景色，而二维码的前景色是0，所以先进行反转。
img_bin = ~logical(img_bin); 

%去除噪声
structor3 = ones(3);
img_opened = img_bin;
%{
for i = 1:1
    img_opened = imgErode(img_opened,structor3);
    img_opened = imgDilate(img_opened,structor3);
end
%}
% 二维码的定位和裁剪
img_417 = imgDetect(img_opened);

%得到二维码的四个顶点
[lines, points] = imgHoughLine(img_417);

%双线性变换
img_bilinear = imgBilinear(img_417,points);

%插值
img_interpolation = imgDilate(img_bilinear,structor3);
img_interpolation = imgErode(img_interpolation,structor3);

%%
%显示结果
figure('Name','test_imgDetect');
subplot(221);imshow(img_bin); title('二值化并取反后');
subplot(222);imshow(img_417); title('截取到的二维码');
subplot(223);imshow(img_bilinear); title('矫正后的二维码');
subplot(224);imshow(img_interpolation); title('插值后的二维码');



