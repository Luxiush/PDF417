%img_in = imread('../b/1933.png');
img_in = imread('../img_test/lv5.jpg');
%img_in = imread('../img_test/lv1.jpg');

img_gray = rgb2gray(img_in);
img_bin = logical(ostu(img_gray));

figure;
imshow(img_gray);title('ԭͼ');
