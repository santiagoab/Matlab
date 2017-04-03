%% 
clc
clear all
close all
addpath('video dataset')

%% video dataset: highway, mobile, paris
dataset = 'highway';
% quality factors
qty   = 1;
qty2   = 2;
% video selection
directory   = strcat(dataset,'/');
image       = strcat(dataset,'_');
%% load dataset
[frames, nframes] = loaddataset( directory, image );

%% Encode and decode video
% It's very slow, lasts 30s - 1min
quality_i = [qty, qty2];
[codedVid] = videoCoder(frames, qty, quality_i );

%% Play decoded video
for i = 1 : nframes	
    videofr = codedVid(:,:,i);
    imshow(videofr);
    pause(4/24)
end
%% Save video to new folder / calculate PSNR, MSE

mkdir(strcat('video dataset/',directory,'codedVideo'));

psnr_coded_vid = 0;
immse_coded_vid = 0;

for i = 1 : nframes	
    videofr   = codedVid(:,:,i);
    imwrite(videofr, strcat('video dataset/',directory,'codedVideo/decodedframe_',image ,num2str(sprintf('%.3d',i)), '.jpg'));
    psnr_coded_vid = psnr_coded_vid + psnr(videofr,frames(:,:,i));
    immse_coded_vid = immse_coded_vid + immse(videofr,frames(:,:,i));
end
fprintf('\n The coded video PSNR is %0.4f\n', psnr_coded_vid/nframes);
fprintf('\n The coded video MSE is %0.4f\n', immse_coded_vid/nframes);

%% Encode and decode JPEG video
[jpegVideo] = jpegCoder(frames, qty );

%% Play JPEG video
for i = 1 : nframes	
    videofr = jpegVideo(:,:,i);
    imshow(videofr);
    pause(4/24)
end
%% Save JPEG video to new folder / calculate PSNR, MSE

mkdir(strcat('video dataset/',directory,'jpegVideo'));
psnr_jpeg_vid = 0;
immse_jpeg_vid = 0;
for i = 1 : nframes	
    videofr   = jpegVideo(:,:,i);
    imwrite(videofr, strcat('video dataset/',directory,'jpegVideo/decodedframe_',image ,num2str(sprintf('%.3d',i)), '.jpg'));
    psnr_jpeg_vid = psnr_jpeg_vid + psnr(videofr,frames(:,:,i));
    immse_jpeg_vid = immse_jpeg_vid + immse(videofr,frames(:,:,i));
end
fprintf('\n The JPEG video PSNR is %0.4f\n', psnr_jpeg_vid/nframes);
fprintf('\n The JPEG video MSE is %0.4f\n', immse_jpeg_vid/nframes);