function [y1]=myifft2(a)
y=zeros(size(a));
y1=y;                           % Preallocation
[R,C]=size(a);                  % Number of rows & columns
for c=1:C
y(:,c)=myifft(a(:,c));          % Row wise FFT
end
for r=1:R
y1(r,:)=myifft(y(r,:).');       % Column wise FFT
end