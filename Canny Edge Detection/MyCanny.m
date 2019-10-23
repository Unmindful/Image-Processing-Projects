function [d4]=MyCanny(a,sigma,tau)
a=double(a);
index=round((2*3*sigma)+1);
h= fspecial('gaussian',index,sigma);
b=myconv(a,h);
cx=[1,0,-1;1,0,-1;1,0,-1];
cy=cx';
dx=myconv(b,cx);
dy=myconv(b,cy);
d1=round(sqrt(dx.^2+dy.^2));
d2=atan2(dy,dx)*180/pi;
[r,c]=size(d1);
for i=1:r
    for j=1:c
        if (d2(i,j)<0) 
            d2(i,j)=360+d2(i,j);
        end
    end
end
d3=zeros(r,c);
for i=1:r
    for j=1:c
        if (d2(i,j)>=0 && d2(i,j)<22.5)||(d2(i,j)>=157.5 && d2(i, j)<202.5)||(d2(i,j)>=337.5 && d2(i,j)<=360)
            d3(i,j)=0;
        elseif (d2(i,j)>=22.5 && d2(i,j)<67.5)||(d2(i,j)>=202.5 && d2(i,j)<247.5)
            d3(i,j)=45;
        elseif (d2(i,j)>=67.5 && d2(i,j)<112.5)||(d2(i,j)>=247.5 && d2(i,j)<292.5)
            d3(i,j)=90;
        elseif (d2(i,j)>=112.5 && d2(i,j)<157.5)||(d2(i,j)>= 292.5 && d2(i,j)<337.5)
            d3(i,j)=135;
        end
    end
end
d4=zeros(r,c);
for i=2:r-1
    for j=2:c-1
        if d3(i,j)==0
            if (d1(i,j)>d1(i,j+1) && d1(i,j)>tau)&&(d1(i,j)>d1(i,j-1) && d1(i,j)>tau)
                d4(i,j)=d1(i,j);
            end
        elseif d3(i,j)==45
            if (d1(i,j)>d1(i-1,j+1) && d1(i,j)>tau)&&(d1(i,j)>d1(i+1,j-1) && d1(i,j)>tau)
                d4(i,j)=d1(i,j);
            end
        elseif d3(i,j)==90
            if (d1(i,j)>d1(i+1,j) && d1(i,j)>tau)&&(d1(i,j)>d1(i-1,j) && d1(i,j)>tau)
                d4(i,j)=d1(i,j);
            end
        else
            if (d1(i,j)>d1(i-1,j-1) && d1(i,j)>tau)&&(d1(i,j)>d1(i+1,j+1) && d1(i,j)>tau)
                d4(i,j)=d1(i,j);
            end
        end
    end
end