function [codedVid] = videoCoder(frames, quality, qualityfactor )
%% Set variables for video coding
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
codedVid = zeros(n,m,numIm);
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
        %% I - frame - we create the I frames with the ifames function
        if sum(x==ipositions) == true
            outputimage = iframes( image, quality );
        end

        %% P - frames - create P frames using previous frame
        if sum(x==ppositions) == true
            frameType= 'P';% save type for later use in framequantizer
            outputimage = pframes( image, frames(:,:,x-3), codedVid(:,:,x-3),frameType, qualityfactor);
        end

        %% B - frames - create B frames using previous and foward frames
        if sum(x==bpositions) == true
            frameType= 'B';
            % previous frame
            prev_f_t = frames(:,:,max(steps.*(steps<x)));
            prev_f_c = codedVid(:,:,max(steps.*(steps<x))); 
            auxf = (steps.*(steps>x));
            % next frame
            next_f_1 = frames(:,:,min(auxf(auxf>0))); 
            next_f_2 = codedVid(:,:,min(auxf(auxf>0))); 
            outputimage = bframes( image, prev_f_t ,next_f_1,prev_f_c,next_f_2,frameType, qualityfactor);
        end

         %encoded video
         codedVid(:,:,x) = outputimage;
         
    end 
end     % for j
end     % Function1

