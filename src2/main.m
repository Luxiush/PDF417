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

%��ֵ��
% img_in = ostu(rgb2gray(img_in)); img_in = logical(img_in);
 level = graythresh(img_in);
 img_in = im2bw(img_in, level);

symchar = getSymbolCharacter(img_in);

codewords = symchar2codeword(symchar);

seq = decode(codewords'); %matlab�о����ǰ��д洢�ģ�����decode��Ҫ���з���
disp('decode result: ');
disp(seq);
toc;
%}

%% ���������
close all;
clear all;
clc;

%% ��ʼ��ʱ
tic;

%% ִ�к���������
disp(func_test('../img/my2.png'));
disp(func_test('../img_final/test4.png'));
disp(func_test('../img_final/test5.png'));

%% ������ʱ�����ʱ��
toc;

