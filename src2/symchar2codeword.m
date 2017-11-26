%% 由符号字符提取码字
function codeword = symchar2codeword(symchar)
    [symchar_size.rows, symchar_size.cols] = size(symchar);
    codeword = zeros(symchar_size.rows,floor(symchar_size.cols/8));

    load symcodes.mat -ascii;

    %解码码字转换
    for r = 1:symchar_size.rows
       cluster = mod(r-1,3)+1; %簇号 0,3,6  ==> 1,2,3 
       temp = 0;
       for c = 1:symchar_size.cols
          temp = temp*10 + symchar(r,c);%计算符号字符
          if(mod(c,8)==0)
              for i = 1:929 %通过查找表，转换为码字
                 if(abs(symcodes(cluster,i)-temp)<0.00000001)
                     codeword(r,floor(c/8)) = i-1; break;
                 end
              end
              temp = 0;
          end
       end
    end
end