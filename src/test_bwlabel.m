img_in = imread('../img/7.png');
img_gray = img_in;

img_bin = logical(ostu(img_gray));

[L,num] = bwlabel(img_bin, 8);

[rows,cols] = size(L);
connected_mun = zeros(num,1);%��¼ÿ����ͨ��Ĵ�С
for r = 1:rows
    for c = 1:cols
       i = L(r,c);
       if(i>0)
           connected_mun(i) = connected_mun(i)+1;
       end
    end    
end

figure;
subplot(121); imshow(img_gray); title('ԭʼ�Ҷ�ͼ��');
subplot(122); imshow(img_bin); title('��ֵͼ��');
figure; image(L/num*255, 'CDataMapping','scaled'); colorbar; title('��ͨͼ');