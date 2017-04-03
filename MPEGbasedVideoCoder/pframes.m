function [ outputimage ] = pframes( frame, previousframe1, previousframe2, type, quality)

%code the p frames
[xsize,ysize] = size(frame);
sizeblock = 16;
dist1 = zeros(xsize,ysize);
dist2 = zeros(xsize/sizeblock,ysize/sizeblock,2);


for n = 1:ysize/sizeblock           % go through all blocks of first frame
    for s = 1:xsize/sizeblock
        size1 = sizeblock*(s-1)+1:sizeblock*s;
        size2 = sizeblock*(n-1)+1:sizeblock*n;
        
        distance = zeros(sizeblock,sizeblock);               

        for x = 1:ysize/sizeblock             % go through all blocks of prev frame
            for k = 1:xsize/sizeblock  
                
                size3 = sizeblock*(k-1)+1:sizeblock*k;
                size4 = sizeblock*(x-1)+1:sizeblock*x; 
                
                subtract = frame(size1,size2) - previousframe1(size3,size4);
                
                if sum(sum(sum(abs(subtract))>sum(abs(distance))))
                    
                    distance = subtract;  %update block distance
                    distx = x;
                    disty = k;
                    
                end
                
            end
            
        end
        
        dist1(size1,size2) = distance;
        dist2(n,s,1) = distx;
        dist2(n,s,2) = disty;
        
    end     
    
end

dist1 = framequantizer( dist1, type, quality);


%decode the p frames through pdecoder function

dist1 = framedequantizer( dist1, type, quality);

[xsize,ysize] = size(previousframe2); 
blocksize = 16;

outputimage = zeros(xsize,ysize);

for n = 1:ysize/blocksize  
    for k = 1:xsize/blocksize
        
        size1 = blocksize*(k-1)+1:blocksize*k;  
        size2 = blocksize*(n-1)+1:blocksize*n;
        
        x = dist2(n,k,1);
        y = dist2(n,k,2);
        
        size3 = blocksize*(y-1)+1:blocksize*y;  
        size4 = blocksize*(x-1)+1:blocksize*x; 
                
        add = previousframe2(size3,size4) + dist1(size1,size2);
        
        outputimage(size1,size2) = add;
        
    end    
    
end

end

