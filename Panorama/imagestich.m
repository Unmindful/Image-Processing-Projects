function img=imagestich(Ib_t,column,row,Ia_rgb)  
[r1,c1]=size(Ib_t);
[r2,c2]=size(Ia_rgb);
r3=abs(round(row(1)));r4=abs(round(row(2)));
c3=abs(round(column(1)));c4=abs(round(column(2)));
rows=r2+r1-r4;
cols=c1+c2-c4;
img=zeros(rows,cols);
img(1:r1,(1+c3):(c1+c3))=Ib_t;
img((1+r3):(r2+r3),1:c2)=Ia_rgb; 
end
