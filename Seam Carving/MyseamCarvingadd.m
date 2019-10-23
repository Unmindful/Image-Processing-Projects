function a=MyseamCarvingadd(a,x,y)
a=double(a);
[x1,y1,~]=size(a);
if x<x1 || y<y1
    error('Dimension Mismatch')
end
x2=x-x1;
y2=y-y1;
for i=1:y2
    a=CarvingHelperadd(a);
end
a=imrotate(a,-90);
for i=1:x2
    a=CarvingHelperadd(a);
end
a=imrotate(a,90);
end
