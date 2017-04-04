%% Ex1 Funciona correcte

a = im2double(imread('a_noisy.png'));
SEsquare = [1 1 1; 1 1 1; 1 1 1];
SEsquare4 = ones(4,4);
SEcross = [0 1 0; 1 1 1; 0 1 0];
figure;
imshow(a);

%binarization
y = a>0.5;
figure;
imshow(y);
title('binariz');

%closing
close = imclose(y,SEcross);
figure;
imshow(close);
title('closing');

%opening
y = imopen(close,SEcross);
figure;
imshow(y);
title('opening');

%erode
y = imerode(y,SEsquare4);
figure;
imshow(y);
title('erode');

%dilate
y = imdilate(y,SEsquare4);
figure;
imshow(y);
title('dilate');

%edge detection
kdx = [0 0 0; 0 -1 1; 0 0 0];
kdy = [0 0 0; 0 -1 0; 0 1 0];
y = im2double(y);
xdx = conv2(y,kdx);
xdy = conv2(y,kdy);
xgrad = sqrt(xdx.^2 + xdy.^2);
imshow(xgrad);
title('Final image');


%% Ex2
a = im2double(imread('letters.png'));
SEsquare6 = ones(6,6);
figure;
imshow(a);

%dilate -------> what we want to extract from the image
y = imdilate(a,SEsquare6);
figure;
imshow(y);
title('Dilate');

%Advanced Morph. Grad.
y = y-a;
figure;
imshow(y);
title('Advanced Morphological Gradient');

%turn previus black tonalities image into white tonalities
y = 1-y;
figure;
imshow(y);
title('White tonality image'); 

%binarization
y = y>0.98;
figure;
imshow(y)
title('Final image');

