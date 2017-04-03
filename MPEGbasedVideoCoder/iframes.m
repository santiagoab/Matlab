function [ imOut ] = iframes( imIn,K )
% K = Compression factor (default 1)
%% Read image / load luminance
im = (im2double(imIn));
[s1,s2] = size(im);
Y = im(:,:,1);
Y = uint8(Y*255);
Y = double(Y) - 128;
%% Block subdivision and DCT
%Luminance channel
for k = 1:8:(size(Y,1)-1)
    for n = 1:8:(size(Y,2)-1)
           YBlock(k:k+7,n:n+7) = dct2(Y(k:k+7,n:n+7));
    end
end

load('Qtables.mat')% We load the quantization tables into the variables
%% Quantization

Qluma = Qluma*K;

%Luminance channel
for k = 1:8:(size(Y,1)-1)
    for n = 1:8:(size(Y,2)-1)
           YQuanti(k:k+7,n:n+7) = round(YBlock(k:k+7,n:n+7)./Qluma);
    end
end

%% Dequantize blocks
for k = 1:8:(size(Y,1)-1)
    for n = 1:8:(size(Y,2)-1)
           YDequant(k:k+7,n:n+7) = round(YQuanti(k:k+7,n:n+7).*Qluma);
    end
end
%% Inverse-DCT (IDCT2)
for k = 1:8:(size(YDequant,1)-1)
    for n = 1:8:(size(YDequant,2)-1)
           YInverse(k:k+7,n:n+7) = idct2(YDequant(k:k+7,n:n+7));
    end
end
YInverse = (YInverse +128);
%% Final Image composition
FinalImage(:,:,1) = YInverse;
imOut = im2double(FinalImage/255);

end

