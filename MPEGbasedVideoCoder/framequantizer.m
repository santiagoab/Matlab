function [image] = framequantizer(image, type, quality)

load('Qinterintra.mat');

if strcmp(type,'P')
    imagequality = quality(1);
else
    imagequality = quality(2);
end

[xsize,ysize] = size(image);

sizeblock = 8;

for n = 1:ysize/sizeblock  
    for k = 1:xsize/sizeblock
        
        xdist = sizeblock*(k-1)+1:sizeblock*k;  
        ydist = sizeblock*(n-1)+1:sizeblock*n;
        
        image(xdist,ydist) = round((image(xdist,ydist)*255)./(Q_inter*imagequality));    
    end  
    
end

end

