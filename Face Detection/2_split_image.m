addpath('cropped_training_images_faces')
addpath('cropped_training_images_notfaces')

%Splitting Training & Validation image not faces


total_image = numel(dir('cropped_training_images_notfaces/*.jpg'));
ntraining_image = 0;
nvalidation_image = 0;
selected_rand=0;

croppedimage_dir = 'cropped_training_images_notfaces';
croppedimage_list = dir(sprintf('%s/*.jpg',croppedimage_dir));

%Splitting Training image not faces
while ntraining_image < round(0.8*total_image)
       
rand_n=randi(total_image);

if rand_n ~= selected_rand(:)
ntraining_image=ntraining_image+1;
training_img_not_face(ntraining_image)=croppedimage_list(rand_n);
selected_rand(ntraining_image)=rand_n;

end

end

%Splitting Validation image not faces
while nvalidation_image < round(0.2*total_image)
       
rand_n=randi(total_image);

if rand_n ~= selected_rand(:)
nvalidation_image=nvalidation_image+1;
validation_img_not_face(nvalidation_image)=croppedimage_list(rand_n);
selected_rand(ntraining_image+nvalidation_image)=rand_n;

end

end

%Splitting Training & Validation image faces


total_image = numel(dir('cropped_training_images_faces/*.jpg'));
ntraining_image = 0;
nvalidation_image = 0;
selected_rand=0;

croppedimage_dir = 'cropped_training_images_faces';
croppedimage_list = dir(sprintf('%s/*.jpg',croppedimage_dir));

%Splitting Training image faces
while ntraining_image < round(0.8*total_image)
       
rand_n=randi(total_image);

if rand_n ~= selected_rand(:)
ntraining_image=ntraining_image+1;
training_img_face(ntraining_image)=croppedimage_list(rand_n);
selected_rand(ntraining_image)=rand_n;

end

end

%Splitting Validation image faces
while nvalidation_image < round(0.2*total_image)
       
rand_n=randi(total_image);

if rand_n ~= selected_rand(:)
nvalidation_image=nvalidation_image+1;
validation_img_face(nvalidation_image)=croppedimage_list(rand_n);
selected_rand(ntraining_image+nvalidation_image)=rand_n;

end

end


save('training_validation.mat','training_img_not_face','validation_img_not_face','training_img_face','validation_img_face')