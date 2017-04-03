function [ frames, nframes ] = loaddataset( directory, image )

nframes = length(dir(strcat('video dataset/',(directory))))-4;

for i = 1:nframes
    file = strcat('video dataset/',directory,image ,num2str(sprintf('%.3d',i)), '.tiff');
    [framefile] = im2double(imread(file,'tiff'));
    framefile = framefile(:,:,1);
    if i == 1
        [xsize,ysize,~] = size(framefile);         
        frames = zeros(xsize,ysize,nframes);                 
    end 
    frames(:,:,i) = framefile;
end
end

