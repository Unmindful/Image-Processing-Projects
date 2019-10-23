%% Part-1
clear;close all;clc;

%Processing image with LPF
a_rgb=double(imread('Kosta.jpg'));

%Calculation for Red Channel
a=a_rgb(1:225,:,1);
[r1,c1]=size(a);
c=zeros(2*r1,2*c1);
[r2,c2]=size(c);
c(1:r1,1:c1)=a;                     %Step1-zero padding of image
d=zeros(r2,c2);
for i=1:r2
for j=1:c2
d(i,j)=c(i,j)*(-1)^(i+j);           %Step2-centering the image for transform
end
end
e=fft2(d);                          %Step3-2-D FFT
H1=myglp(r2,c2,20);                 %Step4-Gaussian Low Pass Filter with redi 20
f1=e.*H1;                           %Step5-Multiplication in Freq domain
g1=ifft2(f1);                       %Step6-2-D IFFT
h1=zeros(r2,c2);
for i=1:r2
for j=1:c2
h1(i,j)=g1(i,j)*((-1).^(i+j));      %Step7-Center Reversal
end
end
k1_r=real(h1(1:r1,1:c1));           %Step8-Removing zero padding

%Calculation for Green Channel
a=a_rgb(1:225,:,2);
[r1,c1]=size(a);
c=zeros(2*r1,2*c1);
[r2,c2]=size(c);
c(1:r1,1:c1)=a;                     %Step1-zero padding of image
d=zeros(r2,c2);
for i=1:r2
for j=1:c2
d(i,j)=c(i,j)*(-1)^(i+j);           %Step2-centering the image for transform
end
end
e=fft2(d);                          %Step3-2-D FFT
H1=myglp(r2,c2,20);                 %Step4-Gaussian Low Pass Filter with redi 20
f1=e.*H1;                           %Step5-Multiplication in Freq domain
g1=ifft2(f1);                       %Step6-2-D IFFT
h1=zeros(r2,c2);
for i=1:r2
for j=1:c2
h1(i,j)=g1(i,j)*((-1).^(i+j));      %Step7-Center Reversal
end
end
k1_g=real(h1(1:r1,1:c1));           %Step8-Removing zero padding

%Calculation for Blue Channel
a=a_rgb(1:225,:,3);
[r1,c1]=size(a);
c=zeros(2*r1,2*c1);
[r2,c2]=size(c);
c(1:r1,1:c1)=a;                     %Step1-zero padding of image
d=zeros(r2,c2);
for i=1:r2
for j=1:c2
d(i,j)=c(i,j)*(-1)^(i+j);           %Step2-centering the image for transform
end
end
e=fft2(d);                          %Step3-2-D FFT
H1=myglp(r2,c2,20);                 %Step4-Gaussian Low Pass Filter with redi 20
f1=e.*H1;                           %Step5-Multiplication in Freq domain
g1=ifft2(f1);                       %Step6-2-D IFFT
h1=zeros(r2,c2);
for i=1:r2
for j=1:c2
h1(i,j)=g1(i,j)*((-1).^(i+j));      %Step7-Center Reversal
end
end
k1_b=real(h1(1:r1,1:c1));           %Step8-Removing zero padding
k1=cat(3,k1_r,k1_g,k1_b);


%Processing image with HPF
b_rgb=double(imread('Dimitri.jpg'));
b_rgb=circshift(b_rgb,[-3,12]);     %Adjustments

%Calculation for Red Channel
b=b_rgb(:,25:end,1);
[r1,c1]=size(b);
c=zeros(2*r1,2*c1);
[r2,c2]=size(c);
c(1:r1,1:c1)=b;                     %Step1-zero padding of image
d=zeros(r2,c2);
for i=1:r2
for j=1:c2
d(i,j)=c(i,j)*(-1)^(i+j);           %Step2-centering the image for transform
end
end
e=fft2(d);                          %Step3-2-D FFT
H1=myghp(r2,c2,20);                 %Step4-Gaussian High Pass Filter with redi 20
f1=e.*H1;                           %Step5-Multiplication in Freq domain
g1=ifft2(f1);                       %Step6-2-D IFFT
h1=zeros(r2,c2);
for i=1:r2
for j=1:c2
h1(i,j)=g1(i,j)*((-1).^(i+j));      %Step7-Center Reversal
end
end
k2_r=real(h1(1:r1,1:c1));           %Step8-Removing zero padding

%Calculation for Green Channel
b=b_rgb(:,25:end,2);
[r1,c1]=size(b);
c=zeros(2*r1,2*c1);
[r2,c2]=size(c);
c(1:r1,1:c1)=b;                     %Step1-zero padding of image
d=zeros(r2,c2);
for i=1:r2
for j=1:c2
d(i,j)=c(i,j)*(-1)^(i+j);           %Step2-centering the image for transform
end
end
e=fft2(d);                          %Step3-2-D FFT
H1=myghp(r2,c2,20);                 %Step4-Gaussian High Pass Filter with redi 20
f1=e.*H1;                           %Step5-Multiplication in Freq domain
g1=ifft2(f1);                       %Step6-2-D IFFT
h1=zeros(r2,c2);
for i=1:r2
for j=1:c2
h1(i,j)=g1(i,j)*((-1).^(i+j));      %Step7-Center Reversal
end
end
k2_g=real(h1(1:r1,1:c1));           %Step8-Removing zero padding

%Calculation for Blue Channel
b=b_rgb(:,25:end,3);
[r1,c1]=size(b);
c=zeros(2*r1,2*c1);
[r2,c2]=size(c);
c(1:r1,1:c1)=b;                     %Step1-zero padding of image
d=zeros(r2,c2);
for i=1:r2
for j=1:c2
d(i,j)=c(i,j)*(-1)^(i+j);           %Step2-centering the image for transform
end
end
e=fft2(d);                          %Step3-2-D FFT
H1=myghp(r2,c2,20);                 %Step4-Gaussian High Pass Filter with redi 20
f1=e.*H1;                           %Step5-Multiplication in Freq domain
g1=ifft2(f1);                       %Step6-2-D IFFT
h1=zeros(r2,c2);
for i=1:r2
for j=1:c2
h1(i,j)=g1(i,j)*((-1).^(i+j));      %Step7-Center Reversal
end
end
k2_b=real(h1(1:r1,1:c1));           %Step8-Removing zero padding
k2=cat(3,k2_r,k2_g,k2_b);
k=k1+k2;                            %Addition of HPF Image & LPF Image
imshow(uint8(k));