
%% 1.3 Mandatory exercise
x = im2double(imread('secret_noisy.png'));
imshow(x);
title('Original image');

fx = fft2(x);
figure;
show_f(fx) ;
title('Original image Fourier Transform');

fa = lpfilter('ideal' ,256 ,256 ,21) ;  
fb = lpfilter('ideal' ,256 ,256 ,23) ;
bp1 = fb - fa;
band_pass = 1 - bp1 ;
figure;
show_f(band_pass);
title('Band-Pass Filter');

figure;
show_f( fx.*band_pass );
title('Filtered  Fast Fourier Transform');

fx_clean = ifft2(fx.*band_pass);
figure;
imshow(abs(fx_clean));
title('Clean image');

%% 2.3 First mandatory exercise 
zeb = im2double(imread('zebra.jpg'));
zeb = rgb2gray(zeb);
zx = size(zeb,1);
zy = size(zeb,2);
zeb2 = zeb(1:2:zx,1:2:zy);
zeb4 = zeb(1:4:zx,1:4:zy);
zeb8 = zeb(1:8:zx,1:8:zy);
zzx = size(zeb4,1);
zzy = size(zeb4,2);



%% 2.4 Second mandatory exercise
%{
SEM 3 EX 7
(a) Calculate DFT of f to obtain the coefficients cn.
(b) Multiply each cn by e?i2?n?/N  to obtain the coefficients dn.
(c) Apply Inverse-DFT to the coefficients dn to obtain the values of g at points within 0, ..., N ?1.
%}

x = [ 0 0 0 0 0 1 1 1 1 1 ];
y = [ 0 0 0 0 1 0 0 0 0 0 ];

fx = fft(x);
fy = fft(y);

for a = 1:length(fx)
    
    fx(a) = fx(a)*exp(-2i*pi*1*a/length(fx));
    fy(a) = fy(a)*exp(-2i*pi*1*a/length(fy));
    
end

xout = abs(ifft(fx))
yout = abs(ifft(fy))

%% 2.5 Third mandatory exercise 
clc
clear all
xx = im2double(imread('lena.png'));
a = 1;
s = size(xx);
A = (1:length(xx));
for j =1:s(1)
    fx = fft(xx(j,:));
    for k = 1:length(fx)
    	fx(k) = fx(k)*exp(-2i*pi*A(j)*a*k/length(fx));
    end
    xout(j,:) = abs(ifft(fx));
end
imshow(xout)

%% 
clc
clear all
xx = im2double(imread('lena.png'));
cen = 10;%Center value
n = length(xx);
xx(n/2,n/2) = cen;
zeropad = zeros(size(xx,1), size(xx,2));
X =  [zeropad, zeropad, zeropad; 
      zeropad, xx,      zeropad; 
      zeropad, zeropad, zeropad]; 
N = length(X); 
a = 1/8;    %Rotation angle(radian)
s = size(xx);
A = (1:N);
fyy = zeros(1, N);
gy = zeros(N, N);
    % First translation
    ang = A*tan(pi*a/2);
    for j =1:N
        fy = fft(X(j,:));
        fyy = fy.*exp(-2i*pi*A(j)*ang/length(fy));
        gy(j,:) = abs(ifft(fyy));
    end
    % Second translation
    gx = zeros(N, N);
    ang = A*sin(pi*a);
    for l =1:N
        fx = fft(gy(:,l));
        fxx = fx.*exp(-2i*pi*A(l)*ang/length(fx))';
        gx(:,l) = abs(ifft(fxx));
    end
    % Third translation
    ang = A*tan(pi*a/2);
    yy = zeros(N, N);
    for m =1:N
        fy = fft(gx(m,:));
        fyy = fy.*exp(-2i*pi*A(m)*ang/length(fy));
        yy(m,:) = abs(ifft(fyy));
    end
%Code to align the image in the middle of the screen
[~, pX] = max(max(yy));
[~, pY] = max(max(yy'));
m = 3/4 * n;
m = ones(1,4)* m;
yy = yy( (pY-m(1)):(pY+m(2)) , (pX-m(3)):(pX+m(4)) );
imshow(yy)
title('1/8 rad rotation');