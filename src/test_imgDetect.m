%��main2�Ļ�������һЩ�Ż���
%1��ͨ�����ұ�ķ���ȥ����߽���������ͨ��
%2����ȡͼ���Ϊ��ȥ��С�����ͨ���ʣ�µĲ���
%    ����ԭͼ��������õ���ά��ȥ��������
%    ��ͨ��ͶӰ��λȷ����ά����������
%    �ٽ��вü��õ��ɾ��Ķ�ά��

%img_rgb = imread('../img/7.png'); 
%img_rgb = imread('../img/test-1.png'); 
img_rgb = imread('../img_test/lv3.jpg'); 
%img_rgb = imread('../img_test/lv6.jpg'); 

img_gray = rgb2gray(img_rgb);

img_bin = ostu(img_gray);
%��Ϊ֮ǰ��Ƶ����͡���ʴ������Ĭ��1Ϊǰ��ɫ������ά���ǰ��ɫ��0�������Ƚ��з�ת��
img_bin = ~logical(img_bin); 

%ȥ������
structor3 = ones(3);
img_opened = img_bin;
%{
for i = 1:1
    img_opened = imgErode(img_opened,structor3);
    img_opened = imgDilate(img_opened,structor3);
end
%}
% ��ά��Ķ�λ�Ͳü�
img_417 = imgDetect(img_opened);

%�õ���ά����ĸ�����
[lines, points] = imgHoughLine(img_417);

%˫���Ա任
img_bilinear = imgBilinear(img_417,points);

%��ֵ
img_interpolation = imgDilate(img_bilinear,structor3);
img_interpolation = imgErode(img_interpolation,structor3);

%%
%��ʾ���
figure('Name','test_imgDetect');
subplot(221);imshow(img_bin); title('��ֵ����ȡ����');
subplot(222);imshow(img_417); title('��ȡ���Ķ�ά��');
subplot(223);imshow(img_bilinear); title('������Ķ�ά��');
subplot(224);imshow(img_interpolation); title('��ֵ��Ķ�ά��');



