function [dist1] = framedequantizer( dist1, type, quality)

%We load the Quantization tables and dequantize P or B frames

load('Qinterintra.mat');

if strcmp(type,'P')
    imagequality = quality(1);
else
    imagequality = quality(2);
end

[xsize,ysize] = size(dist1); 

blocksize = 8;

for i = 1:ysize/blocksize  
    for j = 1:xsize/blocksize
        
        xdist = blocksize*(j-1)+1:blocksize*j;  
        ydist = blocksize*(i-1)+1:blocksize*i;
        
        dist1(xdist,ydist) = round((dist1(xdist,ydist)).*(Q_inter*imagequality));
        
    end     
end

dist1 = dist1/255;

end
