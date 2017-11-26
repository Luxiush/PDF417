%数字解码模块
function seq = numberDecode(codewords)
import java.math.BigInteger; %http://www.yiibai.com/java/math/java_math_biginteger.html
% import; %查看是否已经引入
% methods BigInteger; %查看BigInteger提供的方法, 
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
           temp = char(buffer.toString()); %将Java array转为matlab的char数组
           temp = temp(2:length(temp));%去掉前导的1
           seq = strcat(seq,temp); 
           buffer = BigInteger.ZERO;
        end
    end
end