%文本解码模块
function seq = textDecode(codewords)
%codewords = [883 821 459 841 278 151 62 131 885 899 899 899 899 883 899 853];
%codewords = [883 821 459 841 278 151 62 131 885 899 899 899 899 883 899 853];

    table = [
        %alpha
        65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,32,201,202,204;
        %lower case
        97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,32,205,202,204;
        %mixed
        48,49,50,51,52,53,54,55,56,57,38,13,09,44,58,35,45,46,36,47,43,37,42,61,94,203,32,201,200,204;
        %punctuation
        59,60,62,64,91,92,93,95,96,126,33,13,09,44,58,10,45,46,36,47,34,124,42,40,41,63,123,125,39,200
    ];    
    bs = 913;%字节模式转移

    %文本子模式间的转移符号
    ll=201; ml=202; pl=203; al=200; ps =204; as=205;
    
    %文本子模式声明
    SUBMODE.TA = 11; SUBMODE.TL = 12;
    SUBMODE.TM = 13; SUBMODE.TP = 14;
    submode = SUBMODE.TA;
    subshift = 0;
    
    seq = char(zeros(1,2*length(codewords))); k = 1;
%    seq_num = zeros(2*length(codewords),1); k = 1;
    for i = 1:length(codewords)
        if(codewords(i)==bs)
%            seq = [seq,codewords(i+1)]; % ??
            i = i+1;
        else
            lh = [floor(codewords(i)/30),mod(codewords(i),30)];% low && high
            for j = 1:2
                if(subshift>0)
                    ascii = table(subshift-10,lh(j)+1);
                    subshift = 0;
                else
                    ascii = table(submode-10,lh(j)+1);
                end
                
                switch (ascii)
                    case ll
                        submode = SUBMODE.TL; 
                    case ml
                        submode = SUBMODE.TM; 
                    case pl
                        submode = SUBMODE.TP; 
                    case al
                        submode = SUBMODE.TA;
                    case ps
                        subshift = SUBMODE.TP; 
                    case as
                        subshift = SUBMODE.TA; 
                    otherwise
                        if(ascii > 32)
                            seq(k) = char(ascii); k = k+1;
 %                       seq_num(k) = ascii; k = k+1;                            
                        end
                end
            end
        end
    end
end