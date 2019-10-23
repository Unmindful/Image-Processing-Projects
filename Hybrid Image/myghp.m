function [B]=myghp(r,c,sigma)
A=zeros(r,c);
for i=1:r
    for j=1:c
        A(i,j)=sqrt((i-r/2)^2 + (j-c/2)^2);
    end
end
B=zeros(r,c);
for i = 1:r
    for j = 1:c
         B(i,j)=1-exp(-((A(i,j)^2)/(2*(sigma^2))));
    end
end
end
