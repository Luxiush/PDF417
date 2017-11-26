%图像旋转 reference: http://blog.csdn.net/abee23/article/details/7398749
%系统函数：imrotate
function img_rotated = imgRorate(img_bin, tan_a)%输入二值图像和斜率
    sin_a = sin(atan(tan_a));
    cos_a = cos(atan(tan_a));

    [rows,cols] = size(img_bin);
    new_size = ceil(sqrt(rows*rows+cols*cols));
    img_rotated = uint8(ones(new_size,new_size))*255;%旋转后的图片

    % x对应列数，y对应行数
    condinate = uint32(zeros(rows, cols, 2));%为了避免赋值时越界，先保存每个点旋转后的坐标
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