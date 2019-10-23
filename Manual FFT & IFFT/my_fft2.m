function [xk] = my_fft2(xn)
[n,m]=size(xn);
xk=zeros(size(xn));
for l=0:m-1
    for k=0:n-1
        c1=0;
        for x=0:n-1
            for y=0:m-1
                c= xn(x+1,y+1) * exp(-1i*2*pi*(k*x/n + l*y/m));
                c1=c1+c;
            end
        end
        xk(k+1,l+1)=c1;   
    end
end
end