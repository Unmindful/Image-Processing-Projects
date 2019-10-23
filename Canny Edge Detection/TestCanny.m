%% Part-1
clear;close all;clc;
a=double(rgb2gray(imread('bowl-of-fruit.jpg')));
b=double(rgb2gray(imread('lion.jpg')));
sigma=2.4;
tau=15;
c=MyCanny(a,sigma,tau);
d=MyCanny(b,sigma,tau);
figure()
subplot(1,2,1),imshow(uint8(c),[]);
title('Given Image');
subplot(1,2,2),imshow(uint8(d),[]);
title('My chosen Image');
fprintf('Completed Part1! Press enter to continue...\n');
pause;
%% Part-2
clear;close all;clc;
a=double(rgb2gray(imread('bowl-of-fruit.jpg')));
sigma=2.4;
index=round((2*3*sigma)+1);
h1= fspecial('gaussian',index,sigma);
h2= fspecial('gaussian',[1,index],sigma);
b1=myconv(a,h1);
b2_x=myconv(a,h2);
b2=myconv(b2_x,h2');
fprintf('Gaussian Convolution can be depicted as a sequence of horizontal & Vertical Convolution as b1 and b2 are completely same.\n');
fprintf('Completed Part2! Press enter to continue...\n');
pause;
%% Part-3
clear;close all;clc;
a=imread('bowl-of-fruit.jpg');
a1=double(rgb2gray(a));
sigma=2.4;
tau=15;
c=MyCannyHist(a1,sigma,tau);
figure()
subplot(1,2,1),imshow(uint8(a),[]);
title('Original Image');
subplot(1,2,2),imshow(uint8(c),[]);
title('Canny Image after Hysteresis');
fprintf('Completed Part3! Press enter to continue...\n');
pause;