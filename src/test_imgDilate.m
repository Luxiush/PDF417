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
%��̬ѧ�ع�
%Reference�� http://www.mmorph.com/mmtutor1.0/html/mmtutor/mm060reconstruction.html
img = imread('../img/blob.png'); %ԭͼ��Ϊ��Ĥ��mask��
img = rgb2gray(img);
img = logical(ostu(img));
[row,col]=size(img);
%marker��ʼ��Ϊԭͼ�ı߽�
marker = zeros(row,col);
marker(1,:)=img(1,:);
marker(row,:)=img(row,:);
marker(:,1)=img(:,1);
marker(:,col)=img(:,col);

imshow(marker);title('��ʼ�߽�');

structor = ones(3);%�ṹԪ��

for i = 1:30
    marker = imgDilate(marker,structor);%�Ա߽��������
    marker = marker&img;%���ͺ���ԭͼȡ���� 
end

figure;
subplot(121);
imshow(img);title('ԭͼ');
subplot(122);
imshow(marker);title('�߽�����30�κ�');
