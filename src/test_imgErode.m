A = [0,0,0,0,0,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,0,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;0,0,0,0,255,255,255,255,255,255;255,255,255,255,0,0,255,255,0,255;255,255,255,255,0,0,0,0,0,255;255,255,255,255,0,0,0,0,0,255];
L = logical(A);

S = [1,1,1;
     1,1,1;
     1,1,1];
S = logical(S); 
 
out = imgErode(L,S);

subplot(141);
imshow(L);
subplot(142);
imshow(S);
subplot(143);
imshow(out);
subplot(144);
imshow(imerode(L,S)); %结构元素可由strel生成


