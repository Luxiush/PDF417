%ͼ����ת reference: http://blog.csdn.net/abee23/article/details/7398749
%ϵͳ������imrotate
function img_rotated = imgRorate(img_bin, tan_a)%�����ֵͼ���б��
    sin_a = sin(atan(tan_a));
    cos_a = cos(atan(tan_a));

    [rows,cols] = size(img_bin);
    new_size = ceil(sqrt(rows*rows+cols*cols));
    img_rotated = uint8(ones(new_size,new_size))*255;%��ת���ͼƬ

    % x��Ӧ������y��Ӧ����
    condinate = uint32(zeros(rows, cols, 2));%Ϊ�˱��⸳ֵʱԽ�磬�ȱ���ÿ������ת�������
    for y = 1:rows
       for x = 1:cols
           x2 = ceil(x*cos_a - y*sin_a);
           y2 = ceil(y*cos_a + x*sin_a);
           condinate(y,x,1) = y2;
           condinate(y,x,2) = x2;
       end
    end

    y2_min = min(min(condinate(:,:,1)));
    x2_min = min(min(condinate(:,:,2)));
    if(y2_min<=0) 
        condinate(:,:,1) = condinate(:,:,1)-y2_min+1; 
    end
    if(x2_min<=0) 
        condinate(:,:,2) = condinate(:,:,2)-x2_min+1; 
    end

    for y = 1:rows
       for x = 1:cols
           y2 = condinate(y,x,1);
           x2 = condinate(y,x,2);
           img_rotated(y2,x2) = img_bin(y,x);
       end
    end
end