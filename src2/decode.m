%% ���ֽ���
function seq = decode(codewords)
%%
    %ģʽ֮���ת�Ʒ���
    bl.a = 901; bl.b = 924; %�ֽ�ģʽ����
    nl = 902;%����ģʽ����
    tl = 900;%�ı�ģʽ����    
    
    decode_len = codewords(1);%���������ֳ���
    seq = '';%�����
    
    segment.start = 2;
    segment.end = 2;

%% ��ȡģʽ[����]�����������и����ģʽ�ŵ���ͬģ��
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
                elseif(segment.start==2)%һ��ʼ��û��ģʽת������ʱ��Ĭ��Ϊ�ı�ѹ��ģʽ
                    seq = [seq,textDecode(codewords(segment.start:segment.end-1))];
                end 
            end
        end
    end    
end
