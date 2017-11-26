%测试函数：
function seq = func_test(img_name)

 img_in = imread(img_name); 

%二值化
% img_in = ostu(rgb2gray(img_in)); img_in = logical(img_in);
 level = graythresh(img_in);
 img_in = im2bw(img_in, level);

symchar = getSymbolCharacter(img_in);

codewords = symchar2codeword(symchar);

seq = decode(codewords'); %matlab中矩阵是按列存储的，而在decode中要按行访问
end