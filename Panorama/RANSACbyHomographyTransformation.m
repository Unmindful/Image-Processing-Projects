%% Part-1
clear;close all;clc;
Ia_rgb=imread('Ryerson-left.jpg');
Ib_rgb=imread('Ryerson-right.jpg');
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
    if(s(i)<2500)    %Threshold value less than 2500 for Euclidean distances between the descriptors.
        w=w+1;
        threshold_m(w,1)=m(1,i);
        threshold_m(w,2)=m(2,i);
    end
end
threshold_m=threshold_m(1:w,:);     
%Final features & Inlier Selection
%Mapped one image onto another with Homography transformation estimated by RANSAC. 
%For Homography transformation,used the minimum number of pairwise matches. 
%From inverse transformation, calculated Transformation. 
ultimate_f=0;           %%%%%%%%%Contains most number of inliners and the selected random RANSAC pts.                 
for i=1:150             %Arbitrary selected Iteration                        
    perm=randperm(w,4);                         
    %Coordinate Calculation.
    fa_1=fa(1:2,threshold_m(perm(1),1));
    fb_1=fb(1:2,threshold_m(perm(1),2));
    fa_2=fa(1:2,threshold_m(perm(2),1));
    fb_2=fb(1:2,threshold_m(perm(2),2));
    fa_3=fa(1:2,threshold_m(perm(3),1));
    fb_3=fb(1:2,threshold_m(perm(3),2));
    fa_4=fa(1:2,threshold_m(perm(4),1));
    fb_4=fb(1:2,threshold_m(perm(4),2));   
    A=[fb_1(1),fb_1(2),1,0,0,0,-fb_1(1)*fa_1(1),-fb_1(2)*fa_1(1),-fa_1(1); ...
       0,0,0,fb_1(1),fb_1(2),1,-fb_1(1)*fa_1(2),-fb_1(2)*fa_1(2),-fa_1(2); ...
       fb_2(1),fb_2(2),1,0,0,0,-fb_2(1)*fa_2(1),-fb_2(2)*fa_2(1),-fa_2(1); ...
       0,0,0,fb_2(1),fb_2(2),1,-fb_2(1)*fa_2(2),-fb_2(2)*fa_2(2),-fa_2(2); ...
       fb_3(1),fb_3(2),1,0,0,0,-fb_3(1)*fa_3(1),-fb_3(2)*fa_3(1),-fa_3(1); ...
       0,0,0,fb_3(1),fb_3(2),1,-fb_3(1)*fa_3(2),-fb_3(2)*fa_3(2),-fa_3(2); ...
       fb_4(1),fb_4(2),1,0,0,0,-fb_4(1)*fa_4(1),-fb_4(2)*fa_4(1),-fa_4(1); ...
       0,0,0,fb_4(1),fb_4(2),1,-fb_4(1)*fa_4(2),-fb_4(2)*fa_4(2),-fa_4(2);];
   [U,S,V]=svd(A);
    x=V(:,end);
    H=reshape(x,3,3);   %converts to a 3x3 matrix
    H=H./H(3,3);        %Normalization        
    %All other points less distances than 'row' are inliners.
    row=2000;           %Arbitrary selected 'Row' 
    in_L=zeros(w,1);    %Holds index of threshold matches which are inliners. 
    k=0;
    for i=1:w
        if  ismember(i,perm)==0     %Condition of not picking the point before
            moving_m=fb(1:2,threshold_m(i,2));
            x1=[moving_m(1);moving_m(2);1];
            x2= H*x1;               %Transformed points for Image Right side                           
            fixed_m=fa(1:2,threshold_m(i,1)); 
            Spacing=pdist([x2(1) x2(2); fixed_m(1) fixed_m(2)],'euclidean');   %Euclidean Distance between transformed points of image right side with that of Image left side.
            %Inliner if satisfies condtion.
            if (Spacing<row)
                k=k+1;
                in_L(k)=i;
            end
        end
    end
    in_L=in_L(1:k,1);
    %Based on the most number of inliners, selecting the final fits which contains number of inliners & four random picks. 
    if (ultimate_f<size(in_L,1))       %Picks most number of inliners
        final_in_L =in_L;              %Contains most inliner Locations        
        ultimate_f=size(in_L,1);
    end
end
%Parameter Calculation for Homography Transformation
A=[];
for i=1:size(final_in_L,1)
    %Calculation of points for Homography transformation.
    p1fa=fa(1:2,threshold_m(final_in_L(i),1));
    p1fb=fb(1:2,threshold_m(final_in_L(i),2));
    A=[A;...
       p1fb(1),p1fb(2),1,0,0,0,-p1fb(1)*p1fa(1),-p1fb(2)*p1fa(1),-p1fa(1); ...
       0,0,0,p1fb(1),p1fb(2),1,-p1fb(1)*p1fa(2),-p1fb(2)*p1fa(2),-p1fa(2)]; 
end
%Estimate the Homography transformation
[U,S,V]=svd(A);
x=V(:,end);
H=reshape(x,3,3);
H=H./H(3,3);         %Normalization
%Placing the Homography Transformation
Ia_rgb=double(Ia_rgb);
Ib_rgb=double(Ib_rgb);
T=maketform('projective',H);
[Ib_t,column,row]=imtransform(Ib_rgb,T);  
panaroma_image_r=imagestich(Ib_t(:,:,1),column,row,Ia_rgb(:,:,1));
panaroma_image_g=imagestich(Ib_t(:,:,2),column,row,Ia_rgb(:,:,2));
panaroma_image_b=imagestich(Ib_t(:,:,3),column,row,Ia_rgb(:,:,3));
panaroma_image=cat(3,panaroma_image_r,panaroma_image_g,panaroma_image_b);
imshow(uint8(panaroma_image));title('Ryerson Image Panaroma With Homography Transformation');
fprintf('Completed Part1! Press enter to continue...\n');
pause;
%% Part-2
clear;close all;clc;
Ia_rgb=imread('myselect_Left.png');
Ib_rgb=imread('myselect_Right.png');
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
    if(s(i)<2500)    %Threshold value less than 2500 for Euclidean distances between the descriptors.
        w=w+1;
        threshold_m(w,1)=m(1,i);
        threshold_m(w,2)=m(2,i);
    end
end
threshold_m=threshold_m(1:w,:);     
%Final features & Inlier Selection
%Mapped one image onto another with Homography transformation estimated by RANSAC. 
%For Homography transformation,used the minimum number of pairwise matches. 
%From inverse transformation, calculated Transformation. 
ultimate_f=0;           %Contains most number of inliners and the selected random RANSAC pts.                 
for i=1:150             %Arbitrary selected Iteration                        
    perm=randperm(w,4);                         
    %Coordinate Calculation.
    fa_1=fa(1:2,threshold_m(perm(1),1));
    fb_1=fb(1:2,threshold_m(perm(1),2));
    fa_2=fa(1:2,threshold_m(perm(2),1));
    fb_2=fb(1:2,threshold_m(perm(2),2));
    fa_3=fa(1:2,threshold_m(perm(3),1));
    fb_3=fb(1:2,threshold_m(perm(3),2));
    fa_4=fa(1:2,threshold_m(perm(4),1));
    fb_4=fb(1:2,threshold_m(perm(4),2));   
    A=[fb_1(1),fb_1(2),1,0,0,0,-fb_1(1)*fa_1(1),-fb_1(2)*fa_1(1),-fa_1(1); ...
       0,0,0,fb_1(1),fb_1(2),1,-fb_1(1)*fa_1(2),-fb_1(2)*fa_1(2),-fa_1(2); ...
       fb_2(1),fb_2(2),1,0,0,0,-fb_2(1)*fa_2(1),-fb_2(2)*fa_2(1),-fa_2(1); ...
       0,0,0,fb_2(1),fb_2(2),1,-fb_2(1)*fa_2(2),-fb_2(2)*fa_2(2),-fa_2(2); ...
       fb_3(1),fb_3(2),1,0,0,0,-fb_3(1)*fa_3(1),-fb_3(2)*fa_3(1),-fa_3(1); ...
       0,0,0,fb_3(1),fb_3(2),1,-fb_3(1)*fa_3(2),-fb_3(2)*fa_3(2),-fa_3(2); ...
       fb_4(1),fb_4(2),1,0,0,0,-fb_4(1)*fa_4(1),-fb_4(2)*fa_4(1),-fa_4(1); ...
       0,0,0,fb_4(1),fb_4(2),1,-fb_4(1)*fa_4(2),-fb_4(2)*fa_4(2),-fa_4(2);];
   [U,S,V]=svd(A);
    x=V(:,end);
    H=reshape(x,3,3);   %converts to a 3x3 matrix
    H=H./H(3,3);        %Normalization                    
    %All other points less distances than 'row' are inliners.
    row=2000;           %Arbitrary selected 'Row' 
    in_L=zeros(w,1); 
    %Holds index of threshold matches which are inliners. 
    k=0;
    for i=1:w
        if  ismember(i,perm)==0     %Condition of not picking the point before
            moving_m=fb(1:2,threshold_m(i,2));
            x1=[moving_m(1);moving_m(2);1];
            x2= H*x1;               %Transformed points for Image Right side                           
            fixed_m=fa(1:2,threshold_m(i,1)); 
            Spacing=pdist([x2(1) x2(2); fixed_m(1) fixed_m(2)],'euclidean');   %Euclidean Distance between transformed points of image right side with that of Image left side.
            %Inliner if satisfies condtion.
            if (Spacing<row)
                k=k+1;
                in_L(k)=i;
            end
        end
    end
    in_L=in_L(1:k,1);
    %Based on the most number of inliners, selecting the final fits which contains number of inliners & four random picks. 
    if (ultimate_f<size(in_L,1))       %Picks most number of inliners
        final_in_L =in_L;              %Contains most inliner Locations        
        ultimate_f=size(in_L,1);
    end
end
%Parameter Calculation for Homography Transformation
A=[];
for i=1:size(final_in_L,1)
    %Calculation of points for Homography transformation.
    p1fa=fa(1:2,threshold_m(final_in_L(i),1));
    p1fb=fb(1:2,threshold_m(final_in_L(i),2));
    A=[A;...
       p1fb(1),p1fb(2),1,0,0,0,-p1fb(1)*p1fa(1),-p1fb(2)*p1fa(1),-p1fa(1); ...
       0,0,0,p1fb(1),p1fb(2),1,-p1fb(1)*p1fa(2),-p1fb(2)*p1fa(2),-p1fa(2)]; 
end
%Estimate the Homography transformation
[U,S,V]=svd(A);
x=V(:,end);
H=reshape(x,3,3);
H=H./H(3,3);         %Normalization
%Placing the Homography Transformation
Ia_rgb=double(Ia_rgb);
Ib_rgb=double(Ib_rgb);
T=maketform('projective',H);
[Ib_t,column,row]=imtransform(Ib_rgb,T);  
panaroma_image_r=imagestich(Ib_t(:,:,1),column,row,Ia_rgb(:,:,1));
panaroma_image_g=imagestich(Ib_t(:,:,2),column,row,Ia_rgb(:,:,2));
panaroma_image_b=imagestich(Ib_t(:,:,3),column,row,Ia_rgb(:,:,3));
panaroma_image=cat(3,panaroma_image_r,panaroma_image_g,panaroma_image_b);
imshow(uint8(panaroma_image));title('Selected Image Panaroma With Homography Transformation');
fprintf('Completed Part3! Press enter to continue...\n');
pause;