function [ outputimagefinal ] = bframes( frame, previousframe1, followingframe1, previousframe2, followingframe2, type, quality)


%b frames though coding and decoding of the previous and following p or i
%frames

%% coder previous
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

%% decoder previous
dist1 = framedequantizer( dist1, type, quality);

[xsize,ysize] = size(previousframe2); 
blocksize = 16;

outputimage1 = zeros(xsize,ysize);

for n = 1:ysize/blocksize  
    for k = 1:xsize/blocksize
        
        size1 = blocksize*(k-1)+1:blocksize*k;  
        size2 = blocksize*(n-1)+1:blocksize*n;
        
        x = dist2(n,k,1);
        y = dist2(n,k,2);
        
        size3 = blocksize*(y-1)+1:blocksize*y;  
        size4 = blocksize*(x-1)+1:blocksize*x; 
                
        add = previousframe2(size3,size4) + dist1(size1,size2);
        
        outputimage1(size1,size2) = add;
        
    end    
    
end



%% coder following
[xsize,ysize] = size(frame);
sizeblock = 16;
dist3 = zeros(xsize,ysize);
dist4 = zeros(xsize/sizeblock,ysize/sizeblock,2);


for n = 1:ysize/sizeblock           % go through all blocks of first frame
    for s = 1:xsize/sizeblock
        size1 = sizeblock*(s-1)+1:sizeblock*s;
        size2 = sizeblock*(n-1)+1:sizeblock*n;
        
        distance = zeros(sizeblock,sizeblock);               

        for x = 1:ysize/sizeblock             % go through all blocks of prev frame
            for k = 1:xsize/sizeblock  
                
                size3 = sizeblock*(k-1)+1:sizeblock*k;
                size4 = sizeblock*(x-1)+1:sizeblock*x; 
                
                subtract = frame(size1,size2) - followingframe1(size3,size4);
                
                if sum(sum(sum(abs(subtract))>sum(abs(distance))))
                    
                    distance = subtract;  %update block distance
                    distx = x;
                    disty = k;
                    
                end
                
            end
            
        end
        
        dist3(size1,size2) = distance;
        dist4(n,s,1) = distx;
        dist4(n,s,2) = disty;
        
    end     
    
end

dist3 = framequantizer( dist3, type, quality);

%% decoder following
dist3 = framedequantizer( dist3, type, quality);

[xsize,ysize] = size(followingframe2); 
blocksize = 16;

outputimage2 = zeros(xsize,ysize);

for n = 1:ysize/blocksize  
    for k = 1:xsize/blocksize
        
        size1 = blocksize*(k-1)+1:blocksize*k;  
        size2 = blocksize*(n-1)+1:blocksize*n;
        
        x = dist4(n,k,1);
        y = dist4(n,k,2);
        
        size3 = blocksize*(y-1)+1:blocksize*y;  
        size4 = blocksize*(x-1)+1:blocksize*x; 
                
        add = followingframe2(size3,size4) + dist3(size1,size2);
        
        outputimage2(size1,size2) = add;
        
    end    
    
end




%% Mean between the two frames
outputimagefinal = ((outputimage1+outputimage2)/2);

end
