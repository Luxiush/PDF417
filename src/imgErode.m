%腐蚀
%Reference: http://angeljohnsy.blogspot.com/2012/09/image-erosion-without-using-matlab.html
function img_erodee = imgErode (img_in, structor)
    [irow,icol] = size(img_in);%输入图片的大小
    [srow,scol] = size(structor);%结构元素的大小
    
    structor = logical(structor);
    %扩展图像,四周补1
    img_padded = ones(irow+2*srow,icol+2*scol); 
    img_padded(srow:irow+srow-1,scol:icol+scol-1) = img_in;
    img_erodee = zeros(irow+2*srow,icol+2*scol);

    s_r_c = ceil(srow/2);%结构元素的中点作为原点
    s_c_c = ceil(scol/2);
    
    for r = 1:(irow+srow)
       for c = 1:(icol+scol)
           %如果[结构元素]包含于[当前结构元素所覆盖的原图像]
           if((img_padded(r:r+srow-1,c:c+scol-1)&structor) == structor)
               img_erodee(r+s_r_c-1,c+s_c_c-1) = 1;
           end
       end
    end
    
    img_erodee = logical(img_erodee(srow:irow+srow-1,scol:icol+scol-1));
end