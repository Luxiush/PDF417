%main
%{
tic;
%img_in = imread('../img/week12test.bmp');
%img_in = imread('../img_final/test1.bmp');
%img_in = imread('../img_final/test2.bmp');
%img_in = imread('../img_final/test3.bmp');
%img_in = imread('../img_final/test4.png'); 
%img_in = imread('../img_final/test5.png'); 

 img_in = imread('../img/my2.png'); 

%二值化
% img_in = ostu(rgb2gray(img_in)); img_in = logical(img_in);
 level = graythresh(img_in);
 img_in = im2bw(img_in, level);

symchar = getSymbolCharacter(img_in);

codewords = symchar2codeword(symchar);

seq = decode(codewords'); %matlab中矩阵是按列存储的，而在decode中要按行访问
disp('decode result: ');
disp(seq);
toc;
%}

%% 清空数据域
close all;
clear all;
clc;

%% 开始计时
tic;

%% 执行函数输出结果
disp(func_test('../img/my2.png'));
disp(func_test('../img_final/test4.png'));
disp(func_test('../img_final/test5.png'));

%% 结束计时输出总时长
toc;

