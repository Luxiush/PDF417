%���Ժ�����
function seq = func_test(img_name)

 img_in = imread(img_name); 

%��ֵ��
% img_in = ostu(rgb2gray(img_in)); img_in = logical(img_in);
 level = graythresh(img_in);
 img_in = im2bw(img_in, level);

symchar = getSymbolCharacter(img_in);

codewords = symchar2codeword(symchar);

seq = decode(codewords'); %matlab�о����ǰ��д洢�ģ�����decode��Ҫ���з���
end