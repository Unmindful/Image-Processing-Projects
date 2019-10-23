run('../Face Detection/vlfeat-0.9.21/toolbox/vl_setup')
load('my_svm.mat')

bboxes_f = [];
confidences_f = [];
image_names_f = [];

cellSize = 3;
dim = 36;
threshold=0.8;


    % load and show thde image
    im = im2single(imread('class.jpg'));
    imshow(im);
    hold on;
    im_o=im;
    
    im=struct('name',{im_o});
    
    for i=1:numel(im)
    tempIm = rgb2gray(im(i).name);
    min_size = min(size(tempIm,1),size(tempIm,2));
    scale = 1;
    scale_step = 0.95;
    
    bboxes = zeros(0,4);
    confidences = zeros(0,1);
    image_names = cell(0,1);
    
    while scale*min_size > dim
    % generate a grid of features across the entire image. you may want to 
    % try generating features more densely (i.e., not in a grid)
    tempIm_f = imresize(tempIm,scale);
    feats = vl_hog(tempIm_f,cellSize);
    
    % concatenate the features into 12x12 bins, and classify them (as if they
    % represent 36x36-pixel faces)
    [rows,cols,~] = size(feats);    
    confs = zeros(rows,cols);
    for r=1:rows-(dim/cellSize-1)
        for c=1:cols-(dim/cellSize-1)

        window=feats(r:r+(dim/cellSize-1),c:c+(dim/cellSize-1),:);
        featvector=window(:);
        classifier=featvector'*w+b;
        confs(r,c)=classifier;    
        % create feature vector for the current window and classify it using the SVM model,           
        % take dot product between feature vector and w and add b,
        % store the result in the matrix of confidence scores confs(r,c)

        end
    end
       
    % get the most confident predictions 
    [~,inds] = sort(confs(:),'descend');
    inds = inds(1:45); % (use a bigger number for better recall)
    bbox_temp = [];
    for n=1:numel(inds)        
        [row,col] = ind2sub([size(feats,1) size(feats,2)],inds(n));
        
        bbox = [ col*cellSize/scale ...
                 row*cellSize/scale ...
                ((col*cellSize+dim)/scale-1) ...
                ((row*cellSize+dim)/scale-1)];
        conf = confs(row,col);
        image_name = {im(i).name};
        
        
        % Non-max suppression
        
        overlapRatio = 0;
        if n>1
        overlapRatio = bboxOverlapRatio(bbox,bbox_temp);                 
        
        if overlapRatio>threshold
            bbox=[];conf=[];image_name=[];
        end
        end
        bbox_temp = [bbox_temp; bbox];
        
            
        % save         
        bboxes = [bboxes; bbox];
        confidences = [confidences; conf];
        image_names = [image_names; image_name];
    end
    
    scale = scale * scale_step;
    
    end
    [bboxes_sem_,confidences_sem_]= selectStrongestBbox(bboxes,confidences,'RatioType', 'Union', 'OverlapThreshold',threshold);
    confInd = find(confidences_sem_/max(confidences_sem_)>0.3);
    bboxes_sem=bboxes_sem_(confInd,:);
    confidences_sem=confidences_sem_(confInd,:);
    image_name_sem = image_names(1:length(bboxes_sem));
    
        for i=1:size(bboxes_sem,1)
        plot_rectangle = [bboxes_sem(i,1), bboxes_sem(i,2); ...
            bboxes_sem(i,1), bboxes_sem(i,4); ...
            bboxes_sem(i,3), bboxes_sem(i,4); ...
            bboxes_sem(i,3), bboxes_sem(i,2); ...
            bboxes_sem(i,1), bboxes_sem(i,2)];
        plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');
        end    
    
        bboxes_f = [bboxes_f; bboxes_sem];
        confidences_f = [confidences_f; confidences_sem];
        image_names_f = [image_names_f; image_name_sem];
    end
