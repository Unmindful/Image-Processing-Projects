function a=MyseamCarving(a,x,y)
a=double(a);
[x1,y1,~]=size(a);
if x>x1 || y>y1
    error('Dimension Mismatch')
end
x2=x1-x;
y2=y1-y;
for i=1:y2
    a=CarvingHelper(a);
end
a=imrotate(a,90);
for i=1:x2
    a=CarvingHelper(a);
end
a=imrotate(a,-90);
end
