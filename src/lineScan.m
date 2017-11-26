%线扫描
function leftline2 = lineScan(img)
    [rows,cols] = size(img);
    leftline = uint8(zeros(rows,2));
    
    k=floor(rows/3);%起始行（经验值）
%    k_end = k*2;%为了避免扫到底边，将结束行设为总行数的2/3（根据k的值）
    for j = 1:cols %添加leftline的第一个点
        if(img(k,j)==0)
            leftline(k,1)=k;
            leftline(k,2)=j;
        end
    end
    for i = k+1:rows
        for j = 1:cols
           if(img(i,j)==0 && abs(j-leftline(i-1,2))<10)
              leftline(i,1)=i;
              leftline(i,2)=j;
              img(i,j) = 122;
              break;               
           end
        end
    end
    
    %去掉未赋值的点
    i_begin=uint8(0);
    i_end = uint8(0);
    for i=1:rows
        if(leftline(i,1)>0 && leftline(i,2)>0)
            i_begin = i; break;
        end
    end
    for i=rows:-1:1
        if(leftline(i,1)>0 && leftline(i,2)>0)
            i_end = i; break;
        end
    end
    leftline2 = leftline(i_begin:i_end,1:2);
end