%��ʴ
%Reference: http://angeljohnsy.blogspot.com/2012/09/image-erosion-without-using-matlab.html
function img_erodee = imgErode (img_in, structor)
    [irow,icol] = size(img_in);%����ͼƬ�Ĵ�С
    [srow,scol] = size(structor);%�ṹԪ�صĴ�С
    
    structor = logical(structor);
    %��չͼ��,���ܲ�1
    img_padded = ones(irow+2*srow,icol+2*scol); 
    img_padded(srow:irow+srow-1,scol:icol+scol-1) = img_in;
    img_erodee = zeros(irow+2*srow,icol+2*scol);

    s_r_c = ceil(srow/2);%�ṹԪ�ص��е���Ϊԭ��
    s_c_c = ceil(scol/2);
    
    for r = 1:(irow+srow)
       for c = 1:(icol+scol)
           %���[�ṹԪ��]������[��ǰ�ṹԪ�������ǵ�ԭͼ��]
           if((img_padded(r:r+srow-1,c:c+scol-1)&structor) == structor)
               img_erodee(r+s_r_c-1,c+s_c_c-1) = 1;
           end
       end
    end
    
    img_erodee = logical(img_erodee(srow:irow+srow-1,scol:icol+scol-1));
end