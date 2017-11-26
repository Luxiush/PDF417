%% �ɷ����ַ���ȡ����
function codeword = symchar2codeword(symchar)
    [symchar_size.rows, symchar_size.cols] = size(symchar);
    codeword = zeros(symchar_size.rows,floor(symchar_size.cols/8));

    load symcodes.mat -ascii;

    %��������ת��
    for r = 1:symchar_size.rows
       cluster = mod(r-1,3)+1; %�غ� 0,3,6  ==> 1,2,3 
       temp = 0;
       for c = 1:symchar_size.cols
          temp = temp*10 + symchar(r,c);%��������ַ�
          if(mod(c,8)==0)
              for i = 1:929 %ͨ�����ұ�ת��Ϊ����
                 if(abs(symcodes(cluster,i)-temp)<0.00000001)
                     codeword(r,floor(c/8)) = i-1; break;
                 end
              end
              temp = 0;
          end
       end
    end
end