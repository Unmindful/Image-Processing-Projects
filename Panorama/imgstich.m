function img=imgstich(Ia_t,column,row,Ib_rgb)  
[r1,c1]=size(Ia_t);
[r2,c2]=size(Ib_rgb);
r3=abs(round(row(1)));r4=abs(round(row(2)));
c3=abs(round(column(1)));c4=abs(round(column(2)));
rows=r2+r1-r4;
cols=c1+c2-c4;
img=zeros(rows,cols);
img(1:r1,1:c1)=Ia_t;
img(1+.6*r3:r2+.6*r3,(1+1.095*c3:c2+1.095*c3))=Ib_rgb; 
end
