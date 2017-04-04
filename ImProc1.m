%
%
%
%
%% Excercise 1
x = im2double(imread('dem.gif'));
% imshow(x)
x_w = watershed(x, 8);
x_w_r = label2rgb(x_w);
% imshow(x_w_r)
x_w_r=im2double(x_w_r);
x_w2(:,:,1) = (x_w_r(:,:,1)).*x;
x_w2(:,:,2) = (x_w_r(:,:,2)).*x;
x_w2(:,:,3) = (x_w_r(:,:,3)).*x;
figure;
imshow(x_w2);

%% Excercise 2
f_10 = ones(10,10);
f_20 = ones(20,20);
y = imerode(x,f_20);

x_w_morph = watershed(y, 8);
x_w_r_morph = label2rgb(x_w_morph);
% imshow(x_w_r_morph)
x_w_r_morph=im2double(x_w_r_morph);
x_w2_morph(:,:,1) = (x_w_r_morph(:,:,1)).*x;
x_w2_morph(:,:,2) = (x_w_r_morph(:,:,2)).*x;
x_w2_morph(:,:,3) = (x_w_r_morph(:,:,3)).*x;
figure;
imshow(x_w2_morph);

%% Exercise 3
xx = rgb2gray(im2double(imread('coins5.jpg')));
xx = xx > 0.5;
f_10 = ones(10,10);
f_5 = ones(5,5);
f_8 = ones(8,8);
xx = imopen(xx, f_5);
xx = imerode(xx, f_10);
xx = imerode(xx, f_5);
xx = imopen(xx, f_8);

kdx = [0 0 0; 0 -1 1; 0 0 0];
kdy = [0 0 0; 0 -1 0; 0 1 0];
y = im2double(xx);
xdx = conv2(y,kdx);
xdy = conv2(y,kdy);
xgrad = sqrt(xdx.^2 + xdy.^2);
imshow(xgrad);

ydist = bwdist(y);
ydilate = imdilate(ydist, ones(5,5));
% imshow(xx)
yw = watershed((ydilate));

