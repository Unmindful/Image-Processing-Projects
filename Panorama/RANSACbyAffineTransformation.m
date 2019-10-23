clear;close all;clc;
Ia_rgb=imread('parliament-left.jpg');
Ib_rgb=imread('parliament-right.jpg');
Ia=single(rgb2gray(Ia_rgb)) ;
Ib=single(rgb2gray(Ib_rgb));
%Features & Descriptor selection
[fa,da]=vl_sift(Ia) ;
[fb,db]=vl_sift(Ib) ;
%Matches fa,fb and scores.
%%%Couldn't use dist2 function as it froze my PC everytime and didn't get any output after two hours.
[m,s]=vl_ubcmatch(da,db); [r1,c1]=size(m);                      
%Thresholding
threshold_m=zeros(c1,r1);              
w=0;                                       
for i=1:c1
    if(s(i)<3000)    %Threshold value less than 3000 for Euclidean distances between the descriptors.
        w=w+1;
        threshold_m(w,1)=m(1,i);
        threshold_m(w,2)=m(2,i);
    end
end
threshold_m=threshold_m(1:w,:);     
%Final features & Inlier Selection
%Mapped one image onto another with affine transformation estimated by RANSAC. 
%For affine transformation,used the minimum number of pairwise matches. 
%From inverse transformation, calculated Transformation. 
ultimate_f=0;           %Initial condition for inliners.                 
for i=1:150             %Arbitrary selected Iteration                        
    perm=randperm(w,3);                         
    %Coordinate Calculation.
    fa_1=fa(1:2,threshold_m(perm(1),1));
    fb_1=fb(1:2,threshold_m(perm(1),2));
    fa_2=fa(1:2,threshold_m(perm(2),1));
    fb_2=fb(1:2,threshold_m(perm(2),2));
    fa_3=fa(1:2,threshold_m(perm(3),1));
    fb_3=fb(1:2,threshold_m(perm(3),2));
    %Calculating T & C of affine transformation
    A=[fa_1(2),fa_1(1),0,0,1,0; ...
       0,0,fa_1(2),fa_1(1),0,1; ...
       fa_2(2),fa_2(1),0,0,1,0; ...
       0,0,fa_2(2),fa_2(1),0,1; ...
       fa_3(2),fa_3(1),0,0,1,0; ...
       0,0,fa_3(2),fa_3(1),0,1];
    b=[fb_1(2);fb_1(1);fb_2(2);fb_2(1);fb_3(2);fb_3(1)];
    x=A\b;   
    T=[x(1) x(2);x(3) x(4)];
    c=[x(5);x(6)];
    %All other points less distances than 'row' are inliners.
    row=2000;           %Arbitrary selected 'Row' 
    in_L=zeros(w,1);    %Holds index of threshold matches which are inliners.
    k=0;
    for i=1:w
        if  ismember(i,perm)==0     %Condition of not picking the point before
            moving_m=fa(1:2,threshold_m(i,1));
            x1=[moving_m(2);moving_m(1)];
            x2=T*x1+c;             %Transformed points for Image Left side                           
            fixed_m=fb(1:2,threshold_m(i,2)); 
            Spacing=pdist([x2(2) x2(1); fixed_m(1) fixed_m(2)],'euclidean');   %Euclidean Distance between transformed points of image left side with those of Image right side.
            %Inliner if satisfies condtion.
            if (Spacing<row)
                k=k+1;
                in_L(k)=i;
            end
        end
    end
    in_L=in_L(1:k,1);
    %Based on the most number of inliners, selecting the final fits which contains number of inliners & three random picks. 
    if (ultimate_f<size(in_L,1))        %Picks most number of inliners
        final_in_L=in_L;                %Contains most inliner Locations        
        ultimate_f=size(in_L,1);
    end
end
%Parameter Calculation for Affine Transformation
A=[];b=[];
for i=1:size(final_in_L,1)
    %Calculation of points for affine transformation.
    p1fa=fa(1:2,threshold_m(final_in_L(i),1));
    p1fb=fb(1:2,threshold_m(final_in_L(i),2));
    A=[A;...
       p1fa(2),p1fa(1),0,0,1,0;...
       0,0,p1fa(2),p1fa(1),0,1]; 
    b=[b;p1fb(2);p1fb(1)];
end
%Estimate the affine transformation
x = A\b;
%Placing the Affine Transformation
Ia_rgb=double(Ia_rgb);
Ib_rgb=double(Ib_rgb);
T=maketform('affine',[x(1),x(2),0;x(3),x(4),0;x(5),x(6),1]);
%Image stiching Channelwise
[Ia_t,column,row]=imtransform(Ia_rgb,T);      %Affine transform of the left side image
panaroma_image_r=imgstich(Ia_t(:,:,1),row,column,Ib_rgb(:,:,1));
panaroma_image_g=imgstich(Ia_t(:,:,2),row,column,Ib_rgb(:,:,2));
panaroma_image_b=imgstich(Ia_t(:,:,3),row,column,Ib_rgb(:,:,3));
PanaromaImage=uint8(cat(3,panaroma_image_r,panaroma_image_g,panaroma_image_b));
figure, imshow(PanaromaImage);title('Perlament Image Panaroma With Affine Transformation');