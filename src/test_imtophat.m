%%
img_rgb = imread('../img_test/lv4.jpg'); 
img_gray = rgb2gray(img_rgb);

se = strel('disk',8);
img_tophat = imtophat(img_gray,se);

img_gray2 = imsubtract(imadd(img_gray,imtophat(img_gray,se)),imbothat(img_gray,se));

img_bin = ostu(img_tophat);

figure; imshow(img_gray);title('img_gray');
figure; imshow(img_tophat);title('img_tophat');
figure; imshow(img_gray2);title('img_gray2');
figure; imshow(img_bin);title('img_bin');