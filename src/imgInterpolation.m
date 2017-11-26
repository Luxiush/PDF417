%ÁÙ½ü²åÖµ
function img_interpolation = imgInterpolation(img_bin)
    [rows,cols] = size(img_bin);
    img_interpolation = uint8(zeros(rows,cols));
    for y = 2:rows-1
       for x = 1:cols
           if(img_bin(y-1,x)==img_bin(y+1,x)||img_bin(y,x-1)==img_bin(y,x+1))
              img_interpolation(y,x) = img_bin(y-1,x); 
           end
       end
    end
end