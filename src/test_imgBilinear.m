%˫���Ա任
%                     i
% x    c1 c2 c3 c4    j
%    =             *  i*j
% y    c5 c6 c7 c8    1
% ((i,j)Ϊԭͼ��ĵ㣬(x,y)Ϊ��ͼ�ĵ�)
% --> x = c1*i + c2*j + c3*i*j + c4
%     y = c5*i + c6*j + c7*i*j + c8

%% 
%img_rgb = imread('../img/test.jpg'); img_gray = rgb2gray(img_rgb);
%img_rgb = imread('../img/9.png'); img_gray = rgb2gray(img_rgb);
%img_rgb = imread('../img_test/lv0.bmp'); img_gray = img_rgb;
%img_rgb = imread('../img_test/lv1.jpg'); img_gray = rgb2gray(img_rgb);
img_rgb = imread('../img_test/lv2.jpg'); img_gray = rgb2gray(img_rgb);

%��ֵ��  ��lv2.jpg��Ч��������
img_bin = ostu(img_gray);
%ȡ��
img_bin = ~logical(img_bin);

%ȥ������
structor3 = ones(3);
img_opened = img_bin;
for i = 1:1
    img_opened = imgErode(img_opened,structor3);
    img_opened = imgDilate(img_opened,structor3);
end

%�õ���ά����ĸ�����
[lines, points] = imgHoughLine(img_opened);

%˫���Ա任
img_bilinear = imgBilinear(img_opened,points);

%�ٽ���ֵ ��Ч��������,���ñ����㣩
% img_interpolation = imgInterpolation(img_bilinear);

img_interpolation = imgDilate(img_bilinear,structor3);
img_interpolation = imgErode(img_interpolation,structor3);


%%
%��ʾ���
figure;
subplot(221);imshow(img_bin); title('��ֵ����ȡ����');
subplot(223);imshow(img_bilinear); title('������Ķ�ά��');
subplot(224);imshow(img_interpolation); title('��ֵ��Ķ�ά��');


