%����
function img_dilate = imgDilate (img_in, structor)
    [irow,icol] = size(img_in);%����ͼƬ�Ĵ�С
    [srow,scol] = size(structor);%�ṹԪ�صĴ�С
    
    %��չͼ��
    structor = logical(structor);
    img2 = zeros(irow+2*srow,icol+2*scol);
    img2(srow:irow+srow-1,scol:icol+scol-1) = img_in;
    img_dilate = zeros(irow+2*srow,icol+2*scol);

    s_r_c = ceil(srow/2);%�ṹԪ�ص��е���Ϊԭ��
    s_c_c = ceil(scol/2);
    
    for r = 1:(irow+srow)
       for c = 1:(icol+scol)
           if(img2(r+s_r_c-1,c+s_c_c-1)>0)
               img_dilate(r:r+srow-1,c:c+scol-1) = img_dilate(r:r+srow-1,c:c+scol-1) | structor;
           end
       end
    end
    
    img_dilate = logical(img_dilate(srow:irow+srow-1,scol:icol+scol-1));
end