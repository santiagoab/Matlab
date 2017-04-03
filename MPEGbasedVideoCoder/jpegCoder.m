function [jpegVid] = jpegCoder(frames, quality )
%% Set variables for video coding
% We need these variables in order to create the step vectors that
% will help us do the video coding each frame, even though there are no P
% or B frames here.This is the same code as the videoCoder function but
% without the B and P frames.
[n, m, numIm] = size(frames);    % Image size
freq_I = 15;    % Frequency of frames I
freq_B = 3;     % Frequency of frames B
totaliter = 1:1:numIm;   % Num total iterations
ipositions = 1:freq_I:numIm; % Positions of frames I
bpositions = 1:freq_B:numIm; % Position of frames B
bpositions = setdiff(totaliter,bpositions);% Remove positions of I on vector B
steps = union(ipositions,bpositions);
ppositions = setdiff(totaliter,steps);% Difference between positions for frames B
%   and I respect the total in order to obtain positions of frames B (the rest)
jpegVid = zeros(n,m,numIm);
steps = 1:freq_B:numIm;
stepsb = bpositions;
%% Select frames
for w = 1:2
    if w == 1
        z = steps;
    else
        z = stepsb;
    end
    %% Coder
    for x = z
        image = frames(:,:,x);    %read frame
        outputimage = iframes( image, quality );

         jpegVid(:,:,x) = outputimage;
         
    end 
end     % for j
end     % Function1
