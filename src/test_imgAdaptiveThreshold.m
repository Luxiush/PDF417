%img_rgb = imread('../img_test/lv3.jpg'); img_gray = rgb2gray(img_rgb);
%img_rgb = imread('../img_test/lv4.jpg'); img_gray = rgb2gray(img_rgb);
img_rgb = imread('../img_test/lv5.jpg'); img_gray = rgb2gray(img_rgb);
%img_rgb = imread('../img_test/lv6.jpg'); img_gray = rgb2gray(img_rgb);

img_bin = imgAdaptiveThreshold(img_gray);
img_bin2 = ostu(img_gray);

figure; 
subplot(131); imshow(img_gray); title('ԭͼ');
subplot(132); imshow(img_bin); title('�ֲ�����Ӧ��ֵ��');
subplot(133); imshow(img_bin2); title('ostuȫ����ֵ');

 