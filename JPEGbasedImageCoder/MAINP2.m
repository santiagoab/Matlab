%******************
%** JPEG ENCODER **
%******************

clear all
clc
filename = 'synthetic.png';
imag = imread(filename);   % Read RGB image   
figure;
imshow(imag)
title('RGB input image');      

%% - RGB to YCbCr

im = rgb2ycbcr(imag);   % Convert image to YCrCb
figure;
imshow(im)
title('YCbCr input image');

%% - Downsampling
Cb = im(:,:,2); % Save the Cb channel into a variable
Cr = im(:,:,3); % Save the Cr channel into a variable

ds_value = 2;   % Value we are downsampling by

% To do the downsample, the algorithm we use is based on keeping only 
% the first value each X blocks onto a new matrix. X is the downsampling value.
% The for loops have the size of the downsampled image
for i = 1:(size(im,1)/ds_value)
    for j = 1:(size(im,2)/ds_value)
        % Variables to jump by the scaling factor of the original image
        k = i*ds_value-1;
        l = j*ds_value-1;
        % Matrixes where we save the downsampled value of Cb and Cr
        CbDown(i,j) = Cb(k,l);
        CrDown(i,j) = Cr(k,l);        
    end
end

% subplot(1,2,1);imshow(CbDown);title('Subsampled Cb channel');
% hold on;
% subplot(1,2,2);imshow(CrDown);title('Subsampled Cr channel');

%% Block subdivision and DCT
% apply 8x8 block subdivision and the DCT step
Y = im(:,:,1); % Save the Cb channel into a variable
Y = double(Y) -128;
CbDown = double(CbDown) -128;
CrDown = double(CrDown) -128;

%Luminance channel
for k = 1:8:(size(Y,1)-1)
    for n = 1:8:(size(Y,2)-1)
           YBlock(k:k+7,n:n+7) = dct2(Y(k:k+7,n:n+7));
    end
end

%Chrominance channels
for k = 1:8:(size(CbDown,1)-1)
    for n = 1:8:(size(CbDown,2)-1)
           CbBlock(k:k+7,n:n+7) = dct2(CbDown(k:k+7,n:n+7));
           CrBlock(k:k+7,n:n+7) = dct2(CrDown(k:k+7,n:n+7)); 
    end
end

%% Quantization.
%Divide the Y, Cb, Cr with the correponding Qtables and round the value.
%All the new calculated values ares stored in the same positions the DCT
%values of the Y, Cb and Cr channels was stored before

load('Qtables.mat')% We load the quantization tables into the variables

K = 1; %Compression factor (default 1)

Qluma = Qluma*K;
Qchroma = Qchroma*K;

%Luminance channel
for k = 1:8:(size(Y,1)-1)
    for n = 1:8:(size(Y,2)-1)
           YQuanti(k:k+7,n:n+7) = round(YBlock(k:k+7,n:n+7)./Qluma);
    end
end

%Chrominance channels
for k = 1:8:(size(CbDown,1)-1)
    for n = 1:8:(size(CbDown,2)-1)
           CbQuanti(k:k+7,n:n+7) = round(CbBlock(k:k+7,n:n+7)./Qchroma);
           CrQuanti(k:k+7,n:n+7) = round(CrBlock(k:k+7,n:n+7)./Qchroma); 
    end
end


%%
%******************
%** JPEG DECODER **
%******************

%% Dequantize blocks
%Multiply channels by Qtables to dequantize

%Luminance channel
for k = 1:8:(size(Y,1)-1)
    for n = 1:8:(size(Y,2)-1)
           YDequant(k:k+7,n:n+7) = round(YQuanti(k:k+7,n:n+7).*Qluma);
    end
end

%Chrominance channels
for k = 1:8:(size(CbDown,1)-1)
    for n = 1:8:(size(CbDown,2)-1)
           CbDequant(k:k+7,n:n+7) = round(CbQuanti(k:k+7,n:n+7).*Qchroma);
           CrDequant(k:k+7,n:n+7) = round(CrQuanti(k:k+7,n:n+7).*Qchroma); 
    end
end

%% Inverse-DCT (IDCT2)
%Apply the Inverse-DCT step to each 8x8 block and shift up to 128.

%Luminance channel
for k = 1:8:(size(YDequant,1)-1)
    for n = 1:8:(size(YDequant,2)-1)
           YInverse(k:k+7,n:n+7) = idct2(YDequant(k:k+7,n:n+7));
    end
end

%Chrominance channels
for k = 1:8:(size(CbDequant,1)-1)
    for n = 1:8:(size(CbDequant,2)-1)
           CbInverse(k:k+7,n:n+7) = idct2(CbDequant(k:k+7,n:n+7));
           CrInverse(k:k+7,n:n+7) = idct2(CrDequant(k:k+7,n:n+7)); 
    end
end

%Shift up 128 and return values to uint8
YInverse = (YInverse +128);
CbInverse = (CbInverse +128);
CrInverse = (CrInverse +128);

%% Upsample
% Upsample the Cb and Cr chrominance channels to the original image size
YFinal = YInverse;
CbFinal = zeros(size(im,1),   size(im,2));
CrFinal = zeros(size(im,1),   size(im,2));

for i = 1:size(CbInverse,1)
    for j = 1:size(CbInverse,2)
        k = i*2-1;
        l = j*2-1;
        CbFinal(k:k+1,l:l+1) = CbInverse(i,j);
        CrFinal(k:k+1,l:l+1) = CrInverse(i,j);        
    end
end

%% Final Image composition
% finally form the image with the decoded fields Y, Cb and Cr, and show the
% result

FinalImage = zeros(size(im,1),   size(im,2),   3);

FinalImage(:,:,1) = YFinal;
FinalImage(:,:,2) = CbFinal;
FinalImage(:,:,3) = CrFinal;

figure;
imshow(uint8(FinalImage));
title('Final decoded JPEG image YCbCr');
%% Final YCbCr to RGB

RGBFinalImage = ycbcr2rgb(uint8(FinalImage));
figure;
imshow(RGBFinalImage)
title('Final decoded JPEG Image RGB ');

%% Calculate MSE, PSNR and Q
% MSE
immse_value = immse(RGBFinalImage, imag);
fprintf('\nMSE VALUE = %0.4f\n', immse_value)
% PSNR
psnr_value = psnr(RGBFinalImage, imag);
fprintf('\nPSNR VALUE = %0.4f\n', psnr_value)

% Q value
x_1 = rgb2gray(RGBFinalImage);
y = rgb2gray(imag);
N = size(x_1,1)*size(x_1,2);
x = reshape(x_1, [], N);
y = reshape(y, [], N);
mX = (1/N)*sum(x);
mY = (1/N)*sum(y);
sX = sqrt((1/N)*sum((x-mX).^2));
sY = sqrt((1/N)*sum((y-mY).^2));
sXY = (1/N)*sum((y-mY).*(x-mX));
Q = (4*sXY*mX*mY)/((sX.^2 + sY.^2)*(mX.^2 + mY.^2));
fprintf('\nThe image Quality factor (Q) is %0.4f\n', Q);

%% Calculate compress ratio
imwrite(RGBFinalImage, 'result_imag.jpeg');
D_result = dir('result_imag.jpeg');
D_original = dir(filename);
C_ratio = D_original.bytes / D_result.bytes;
fprintf('\nCOMPRESSION RATIO = %0.4f:1\n', round(C_ratio))
