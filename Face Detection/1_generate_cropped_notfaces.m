% you might want to have as many negative examples as positive examples
n_have = 0;
n_want = numel(dir('cropped_training_images_faces/*.jpg'));

imageDir = 'images_notfaces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_imageDir = 'cropped_training_images_notfaces';
mkdir(new_imageDir);

dim = 36;

addpath('images_notfaces');

while n_have < n_want
   
n_have=n_have+1;
img=imread(imageList(randi(nImages)).name);
[r,c,~]=size(img);
crop_image = img(randi(r-dim+1)+(0:dim-1),randi(c-dim+1)+(0:dim-1), :);  % generate random 36x36 crops from the non-face images
patch_name=sprintf('cropped_training_images_notfaces/notface_00%d.jpg',n_have);  
imwrite(crop_image, patch_name);

end