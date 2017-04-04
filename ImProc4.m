x = imread('lemmy.jpg');
subplot(2,2,1)
imshow(x); 
title('Original');
%%
y=255-x; %% inversion de colores imagen color [255 0]
subplot(2,2,2)
imshow(y); 
title('Original invertida');
%%
g = rgb2hsv(x);
g(:,:,2) = 0; %% bajamos la saturacion a 0, ya que no hay color en una escala de grises, y la saturacion nos dice cuanot nivel de color hay en una imagen
subplot(2,2,3)
w = hsv2rgb(g);
imshow(w);
title('Gris');
%%
z=1-w;%inversion colores grayscale [1 0]
subplot(2,2,4)
imshow(z);
title('Gris invertida');