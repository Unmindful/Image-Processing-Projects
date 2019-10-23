function [B]=myconv(a,b)
if nargin<2
error('must have three input argument');
end
 a=double(a);
 [r,c]=size(a);
 b=b(end:-1:1,end:-1:1);
 [r1,c1]=size(b);
 if rem(r1,2)==0
     r2=r1/2;
 else
     r2=(r1-1)/2;
 end
 if rem(c1,2)==0
     c2=c1/2;
 else
     c2=(c1-1)/2;
 end 
 b1=zeros(r+2*r2,c+2*c2);
 b1((1+r2):(r+r2),(1+c2):(c+c2))=a(:,:);
 B=zeros(r,c);
 for  i=1:r
     for j=1:c
        for i1=1:r1
           for j1=1:c1
               B(i,j)=B(i,j)+b1((i1+i-1),(j1+j-1))*b(i1,j1);
           end
        end
      end
end
end