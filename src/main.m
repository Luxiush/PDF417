imgrgb = imread('../img/0.bmp');

%%
%��ֵ��
img_bin = ostu(imgrgb);

%%
%��ɨ��
leftline = lineScan(img_bin);

num = size(leftline,1);
for i = 1:num
    imgrgb(leftline(i,1),leftline(i,2),1)=255; 
end
figure;
imshow(imgrgb);title('��ɨ����');

%%
%ֱ�����,����ת�Ƕ�
leftline2 = double(leftline(2:78,1:2)); % ??????
k = polyfit(leftline2(:,1),leftline2(:,2),1);

plot(leftline(:,1),leftline(:,2),'.');
hold on;
plot(leftline2(:,1),leftline2(:,2), 'Color',[0,1,0]);
leftline_eval = polyval(k,leftline2(:,1));
plot(leftline2(:,1),leftline_eval, 'Color',[1,0,0]);
xlabel('����'); ylabel('����');
hold off;

%%
%ͼ����ת
img_rotated = imgRorate(img_bin, k(1));
figure;
imshow(img_rotated); title('��ת��ͼ��');

%%
%�ٽ���ֵ
[rows,cols] = size(img_bin);
for y = 2:rows-1
   for x = 1:cols
       if(img_rotated(y-1,x) == img_rotated(y+1,x))
          img_rotated(y,x) = img_rotated(y-1,x); 
       end
   end
end
figure;
imshow(img_rotated); title('�ٽ���ֵ��');

%%













