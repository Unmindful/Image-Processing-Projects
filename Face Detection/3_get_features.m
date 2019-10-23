close all
clear
run('../Face Detection/vlfeat-0.9.21/toolbox/vl_setup.m')
load('training_validation.mat')
addpath('cropped_training_images_faces')
addpath('cropped_training_images_notfaces')

cellSize = 3;

% Feature Generation for training set

pos_imageList_training = training_img_face;
pos_nImages_training = length(pos_imageList_training);

neg_imageList_training = training_img_not_face;
neg_nImages_training = length(neg_imageList_training);

featSize = 31*round(36/cellSize)^2;

pos_feats_training = zeros(pos_nImages_training,featSize);

for i=1:pos_nImages_training
    im = im2single(imread(pos_imageList_training(i).name));
    feat = vl_hog(im,cellSize);
    pos_feats_training(i,:) = feat(:);
%      fprintf('got feat for pos image %d/%d\n',i,pos_nImages_training);
%      imhog = vl_hog('render', feat);
%      subplot(1,2,1);
%      imshow(im);
%      subplot(1,2,2);
%      imshow(imhog)
%      pause;
end

neg_feats_training = zeros(neg_nImages_training,featSize);
for i=1:neg_nImages_training
    im = im2single(imread(neg_imageList_training(i).name));
    feat = vl_hog(im,cellSize);
    neg_feats_training(i,:) = feat(:);
%     fprintf('got feat for neg image %d/%d\n',i,neg_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

save('training_feats.mat','pos_feats_training','neg_feats_training',...
     'pos_nImages_training','neg_nImages_training')

 
% Feature Generation for validation set

pos_imageList_validation = validation_img_face;
pos_nImages_validation = length(pos_imageList_validation);

neg_imageList_validation = validation_img_not_face;
neg_nImages_validation = length(neg_imageList_validation);

featSize = 31*round(36/cellSize)^2;

pos_feats_validation = zeros(pos_nImages_validation,featSize);
for i=1:pos_nImages_validation
    im = im2single(imread(pos_imageList_validation(i).name));
    feat = vl_hog(im,cellSize);
    pos_feats_validation(i,:) = feat(:);
%     fprintf('got feat for pos image %d/%d\n',i,pos_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

neg_feats_validation = zeros(neg_nImages_validation,featSize);
for i=1:neg_nImages_validation
    im = im2single(imread(neg_imageList_validation(i).name));
    feat = vl_hog(im,cellSize);
    neg_feats_validation(i,:) = feat(:);
%     fprintf('got feat for neg image %d/%d\n',i,neg_nImages);
%     imhog = vl_hog('render', feat);
%     subplot(1,2,1);
%     imshow(im);
%     subplot(1,2,2);
%     imshow(imhog)
%     pause;
end

save('validation_feats.mat','pos_feats_validation','neg_feats_validation',...
     'pos_nImages_validation','neg_nImages_validation')