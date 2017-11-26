%% 码字解码
function seq = decode(codewords)
%%
    %模式之间的转移符号
    bl.a = 901; bl.b = 924; %字节模式锁定
    nl = 902;%数字模式锁定
    tl = 900;%文本模式锁定    
    
    decode_len = codewords(1);%待解码码字长度
    seq = '';%最后结果
    
    segment.start = 2;
    segment.end = 2;

%% 提取模式[锁定]符，将输入切割根据模式放到不同模块
    for cw_i = 2:decode_len
        codeword = codewords(cw_i);
%        if(codeword==bl.a||codeword==bl.b||codeword==nl||codeword==tl||cw_i==decode_len)
         if(codeword >= 900 || cw_i==decode_len)
            segment.start = segment.end;
            
            if(codeword >= 900)
                segment.end = cw_i; 
            else
                segment.end = cw_i+1;
            end
                        
            if(segment.end-segment.start > 1)
                if(codewords(segment.start)==bl.a||codewords(segment.start)==bl.b)
    %                seq = [seq,byteDecode(codewords(segment.start+1:segment.end-1))];
                elseif(codewords(segment.start)==nl)
                    seq = [seq,numberDecode(codewords(segment.start+1:segment.end-1))];
                elseif(codewords(segment.start)==tl)
                    seq = [seq,textDecode(codewords(segment.start+1:segment.end-1))];
                elseif(segment.start==2)%一开始，没有模式转换符的时候，默认为文本压缩模式
                    seq = [seq,textDecode(codewords(segment.start:segment.end-1))];
                end 
            end
        end
    end    
end
