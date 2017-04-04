%% Subband-Coding based on FFT
close all
clear all
fs = 44100;
waveIn = audioread('es01_m44.wav'); %read wav
a = length(waveIn);
b = ceil(a/1024);
c = b*1024;
z = c-a;
waveIn = [waveIn;zeros(z, 1)]; %zero padding
winL = reshape(waveIn,[],1024); %separate wav to 1204 sample chunks
x = fft(winL);

% plot magnitude, phase, real and imaginary part of segment of the signal
figure;
plot(winL(:,11));
title('Signal DFT');

figure;
subplot(2, 2, 1)
plot(abs(x(:,11)));
title('Magnitude');

phs = unwrap(angle(x(:,11)));
subplot(2, 2, 2)
plot(phs)
title('Phase');

subplot(2, 2, 3)
plot(imag(x(:,11))) 
title('Imaginary part');

subplot(2, 2, 4)
plot(real(x(:,11)))  
title('Real Part');

winO = ifft(x);
waveOut = reshape(winO,length(waveIn), []);
figure;
plot(winO(:,11))
title('IDFT signal');

%% Ex 2
close all
clear all
clc
fs = 44100;
N = 1024;
waveIn = audioread('es01_m44.wav'); %read wav
a = length(waveIn);
b = ceil(a/N);
c = b*N;
z = c-a;
waveIn = [waveIn;zeros(z, 1)]; %zero padding
winL = reshape(waveIn,[],1024); %separate wav to 1204 sample chunks
a = fft(winL);
B_1 = a(:, 1             : floor(N/32));
B_2 = a(:, floor(N/32+1) : floor(N/16));
B_3 = a(:, floor(N/16+1) : floor(N/8));
B_4 = a(:, floor(N/8+1)  : floor(N/4));
B_5 = a(:, floor(N/4+1)  : floor(N/2));

% Ex 3
Q = 8;
[ampQ_1, level_1]=quantimaxmin(B_1,Q,sqrt(N),sqrt(N)/2);
[ampQ_2, level_2]=quantimaxmin(B_2,Q,sqrt(N)/2,sqrt(N)/4);
[ampQ_3, level_3]=quantimaxmin(B_3,Q,sqrt(N)/4,sqrt(N)/8);
[ampQ_4, level_4]=quantimaxmin(B_4,Q,sqrt(N)/8,sqrt(N)/16);
[ampQ_5, level_5]=quantimaxmin(B_5,Q,sqrt(N)/16,0);

BB = [level_1  level_2  level_3 ...
      level_4  level_5];

yy = [-BB(end:-1:1,:)  BB];
yOut = ifft(yy);
yOut = real(yOut);
yOut = reshape(yOut,length(waveIn), []);
% soundsc(yOut, fs)
