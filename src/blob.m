%http://www.mmorph.com/mmtutor1.0/html/mmtutor/mm060reconstruction.html
F=imread('../img/blob.png');
M=mmframe(F);
mmshow(F,mmdil(M,mmsebox(2)));
G1=mminfrec(M,F); % detect cells connected to border
mmshow(G1);
G2=mmsubm(F,G1);
mmshow(G2);