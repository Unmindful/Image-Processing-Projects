function [xn] = my_ifft2(xk)
[n,m]=size(xk);
xn=zeros(size(xk));
for l=0:m-1
    for k=0:n-1
        c1=0;
        for x=0:n-1
            for y=0:m-1
                c= (1/(m*n))*xk(x+1,y+1) * exp(1i*2*pi*(k*x/n + l*y/m));
                c1=c1+c;
            end
        end
        xn(k+1,l+1)=c1;   
    end
end
end