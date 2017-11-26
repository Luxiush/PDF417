%%
%img_rgb = imread('../a/1.png');
img_rgb = imread('../a/2.png');
%img_rgb = imread('../a/3.png');
%img_rgb = imread('../a/4.png');
%img_rgb = imread('../a/5.png');

%img_rgb = imread('../img/113.png');
%img_rgb = imread('../img/test.jpg');
img_gray = rgb2gray(img_rgb);
%img_gray = img_rgb;
img_bin = ostu(img_gray);
img_bin = ~logical(img_bin);

%lines保存边界直线 lines(:,1)为在img_hough中对应点的值; lines(:,2)为rho; lines(:,3)为theta
%point保存直线的交点,第一维到原点的距离，第二维x坐标，第三维y坐标
[lines,points] = imgHoughLine(img_bin);



