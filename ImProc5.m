close all
clear all
%Original
x= imread('dni.jpg');
subplot(2, 2, 1)
imshow(x)
title('Original')
%Negatiu color
y = 255 - x;
subplot(2, 2, 2)
imshow(y)
title('Original negativa')
% HSV
g= rgb2hsv(x);
g(:,:,2) = 0;
subplot(2, 2, 3)
w = hsv2rgb(g);
imshow(w);
title('Gris')
%Negatiu hsv
z = 1 - w;
subplot(2, 2, 4)
imshow(z);
title('Gris Negativa')
%%
close all
clear all
%Original
x= imread('dni.jpg');
h = rgb2hsv(x);
y = h(:,:,2);
for i = size(y,1)
    for j = size(y,2)
        if y(i, j) < 0.02
            y(i, j) = 1;
        else
            y(i,j) = 0;
        end
    end
end

imshow(y)
