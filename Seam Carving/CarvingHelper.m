function a1=CarvingHelper(a)
a1=double(a);
aR=a1(:,:,1);
aG=a1(:,:,2);
aB=a1(:,:,3);
cx=[1,0,-1;1,0,-1;1,0,-1];
cy=cx';
dx_R=myconv(aR,cx);
dy_R=myconv(aR,cy);
E_R=round(sqrt(dx_R.^2+dy_R.^2));
dx_G=myconv(aG,cx);
dy_G=myconv(aG,cy);
E_G=round(sqrt(dx_G.^2+dy_G.^2));
dx_B=myconv(aB,cx);
dy_B=myconv(aB,cy);
E_B=round(sqrt(dx_B.^2+dy_B.^2));
E=(E_R+E_G+E_B)*(1/3);
[x,y]=size(E);
M=zeros(x,y);
M(1,:)=E(1,:);
for i=2:x
    for j=1:y
        if j-1<=0
           N=[M(i-1,j),M(i-1,j+1)];
        elseif j+1>=y
           N=[M(i-1,j-1),M(i-1,j)];
        else
           N=[M(i-1,j-1),M(i-1,j),M(i-1,j+1)];
        end
           M(i,j)=E(i,j)+min(N);   
    end
end
[x1,y1]=size(M);
S=zeros(x1,1);
[~,p]=min(M(x1));
S(x1)=p;
for i=x1-1:-1:1
    if S(i+1)==1
        N1=[M(i,S(i+1)),M(i,(S(i+1)+1))];
        [~,p]=min(N1);
        S(i)=p;
    elseif S(i+1)==y1
        N1=[M(i,(S(i+1)-1)),M(i,S(i+1))];
        [~,p]=min(N1);
        S(i)=y1-2+p;
    else
        N1=[M(i,(S(i+1)-1)),M(i,S(i+1)),M(i,(S(i+1)+1))];
        [~,p]=min(N1);
        S(i)=S(i+1)-2+p;
    end
end
[x3,y3,z3]=size(a1);
M1=zeros(x3,y3-1,z3);
for i=1:x3
    if S(i,1)==1
       M1(i,:,:)=a1(i,2:y3,:);
    elseif S(i,1)==y3
       M1(i,:,:)=a1(i,1:y3-1,:);
    else
       M1(i,:,:)=[a1(i,1:S(i,1)-1,:),a1(i,S(i,1)+1:y3,:)];
    end
end
a1=M1;
end