%圆形结构元素生成
%输入圆的半径r
function disk = struDiskGenerator(r)
    disk = zeros(2*r+1);
    for i = 1:2*r+1
       for j = 1:2*r+1
          if(round(sqrt((i-r-1)^2+(j-r-1)^2))<=r)
             disk(i,j) = 1; 
          end
       end
    end
end

