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

%lines����߽�ֱ�� lines(:,1)Ϊ��img_hough�ж�Ӧ���ֵ; lines(:,2)Ϊrho; lines(:,3)Ϊtheta
%point����ֱ�ߵĽ���,��һά��ԭ��ľ��룬�ڶ�άx���꣬����άy����
[lines,points] = imgHoughLine(img_bin);



