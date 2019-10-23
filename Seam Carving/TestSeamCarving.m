%% Part-1
clear;close all;clc;
fprintf('Output Images are saved in the folder as Ryerson_480x640,Ryerson_720x380,MyImage_650x600.Total output will take 5 minutes of time.\n');
I=double(imread('ryerson.jpg'));
I1=MyseamCarving(I,480,640);
I2=MyseamCarving(I,320,720);
figure(1)
subplot(1,2,1),imshow(uint8(I1),[]);
title('Seamed Image of size 640x480');
subplot(1,2,2),imshow(uint8(I2),[]);
title('Seamed Image of size 720x320');
J=double(imread('MyImage.jpg'));
J1=MyseamCarving(J,650,600);
figure(2)
subplot(1,2,1),imshow(uint8(J),[]);
title('My Original Image of 800x700');
subplot(1,2,2),imshow(uint8(J1),[]);
title('Seamed Image of size 650x600');
fprintf('Completed Part1! Press enter to continue...\n');
pause;
%% Part-2
fprintf('Prepared the function and named MyseamCarvingadd and CarvingHelperadd\n')
fprintf('Finished!!! Thanks for patience\n')