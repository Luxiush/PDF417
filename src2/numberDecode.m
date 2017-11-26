%���ֽ���ģ��
function seq = numberDecode(codewords)
import java.math.BigInteger; %http://www.yiibai.com/java/math/java_math_biginteger.html
% import; %�鿴�Ƿ��Ѿ�����
% methods BigInteger; %�鿴BigInteger�ṩ�ķ���, 
%codewords = [3,393,512,563,733,323,226,640,819,496,645];

    code_len = length(codewords);
    seq = '';
    
    base = BigInteger.valueOf(900);
    buffer = BigInteger.ZERO;
    
    for i = 1:code_len
        %buffer = buffer*900+codewords(i);
        buffer = buffer.multiply(base);
        buffer = buffer.add(BigInteger.valueOf(codewords(i))); 
        if(mod(i,15)==0||i==code_len)
           temp = char(buffer.toString()); %��Java arrayתΪmatlab��char����
           temp = temp(2:length(temp));%ȥ��ǰ����1
           seq = strcat(seq,temp); 
           buffer = BigInteger.ZERO;
        end
    end
end