run('../Face Detection/vlfeat-0.9.21/toolbox/vl_setup')
load('training_feats.mat')
load('validation_feats.mat')

feats = cat(1,pos_feats_training,neg_feats_training);
labels = cat(1,ones(pos_nImages_training,1),-1*ones(neg_nImages_training,1));

lambda = 0.00000001;
[w,b] = vl_svmtrain(feats',labels',lambda);

% Performance on Training Data

fprintf('Classifier performance on training data set:\n')
confidences = [pos_feats_training; neg_feats_training]*w + b;

[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, labels);

% Performance on Validation Data

labels = cat(1,ones(pos_nImages_validation,1),-1*ones(neg_nImages_validation,1));
fprintf('Classifier performance on validation data set:\n')
confidences = [pos_feats_validation; neg_feats_validation]*w + b;

[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, labels);
save('my_svm.mat','w','b')