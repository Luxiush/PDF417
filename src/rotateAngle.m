%������ת�Ƕ�:��leftline�е�������������б��ȡ��ֵ
%function angle = rotateAngle(leftline)
    rows = uint32(length(leftline2(:,1)));
    arrlength = uint32((rows*(rows-1))/2);
    tanarr = double(ones(arrlength,1)*(-1000));%��¼������б��
    
    mark = 0;
    flag = 0;
    for i=1:1:rows
       for j=i+1:1:rows
           num = leftline2(j,2)-leftline2(i,2);
           den = leftline2(j,1)-leftline2(i,1);
           tanarr(i+j-2) = (leftline2(j,2)-leftline2(i,2))/(leftline2(j,1)-leftline2(i,1));
           if(tanarr(i+j-2)==-1000) flag = 1; break; end
           mark = mark+1;
       end
       if(flag == 1) break; end;
    end
    tanarr2 = sort(tanarr);
    angle = median(tanarr);%������������ֵ
    
%end