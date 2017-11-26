%双线性变换
%                     i
% x    c1 c2 c3 c4    j
%    =             *  i*j
% y    c5 c6 c7 c8    1
% ((i,j)为原图像的点，(x,y)为新图的点)
% --> x = c1*i + c2*j + c3*i*j + c4
%     y = c5*i + c6*j + c7*i*j + c8

%% 
%img_rgb = imread('../img/test.jpg'); img_gray = rgb2gray(img_rgb);
%img_rgb = imread('../img/9.png'); img_gray = rgb2gray(img_rgb);
%img_rgb = imread('../img_test/lv0.bmp'); img_gray = img_rgb;
%img_rgb = imread('../img_test/lv1.jpg'); img_gray = rgb2gray(img_rgb);
img_rgb = imread('../img_test/lv2.jpg'); img_gray = rgb2gray(img_rgb);

%二值化  对lv2.jpg的效果不理想
img_bin = ostu(img_gray);
%取反
img_bin = ~logical(img_bin);

%去除噪声
structor3 = ones(3);
img_opened = img_bin;
for i = 1:1
    img_opened = imgErode(img_opened,structor3);
    img_opened = imgDilate(img_opened,structor3);
end

%得到二维码的四个顶点
[lines, points] = imgHoughLine(img_opened);

%双线性变换
img_bilinear = imgBilinear(img_opened,points);

%临近插值 （效果不理想,改用闭运算）
% img_interpolation = imgInterpolation(img_bilinear);

img_interpolation = imgDilate(img_bilinear,structor3);
img_interpolation = imgErode(img_interpolation,structor3);


%%
%显示结果
figure;
subplot(221);imshow(img_bin); title('二值化并取反后');
subplot(223);imshow(img_bilinear); title('矫正后的二维码');
subplot(224);imshow(img_interpolation); title('插值后的二维码');


