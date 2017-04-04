clear all
IM = imread('arrow.jpeg');  % image name
kern_size = 100;
x = kern_size;
y = kern_size;
lambda = 1;
phi = 0;
sigma = .56*lambda;
gamma = .5;
theta= 0; %Rotacion de los filtros
c = 1;
figure

for theta = [0 1/4 2/4 3/4] ;  % angles loop (use 4 values for the angle; if you want to use more you have to change the code for plotting)
    kernel = gabor_kernel(x, y, lambda, phi, sigma,gamma,theta);  % create a function that returns the kernel
    convimker = conv2(double(sum(IM,3)),kernel, 'same');  % convolution of the image with kernel
    % graphics of the result of the convolution
    subplot(4,4,c:c+1)
    imagesc(kernel)  % the result of the convolution
    colormap('bone')
    title(['angle = ' num2str(theta) '\pi'])  % write here the value of the angle
    axis off
    colorbar()
    c = c+2;
      
end
subplot(4,4,9:16)
imshow(IM)  % show the image
axis off