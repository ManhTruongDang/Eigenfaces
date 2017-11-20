clear

%% Initialization (machine-dependent so you should change this part to suit
% yours)

numImages = 36;
k = 10; % Number of eigenfaces that we need
% preDir = 'D:/Hoctap/MachineLearning/CSE_455_Projects/CSE_455_Project_2/class_images/';
preDir = '/class_images/';
middleDir = '/face';
postDir = '.jpg';

smile = 'smiling_cropped';
notSmile = 'nonsmiling_cropped';

% Load the images and convert to grayscale
smiling_cropped = cell(1,numImages);
nonsmiling_cropped = cell(1,numImages);
for i = 1 : numImages
    dir = strcat(preDir,smile,middleDir,num2str(i),postDir);    
    smiling_cropped{i} = rgb2gray(imread(dir));     
    dir = strcat(preDir,notSmile,middleDir,num2str(i),postDir);
    nonsmiling_cropped{i} = rgb2gray(imread(dir));       
end
% Some (noisy) non-faces and cartoon faces taken randomly
nonface01 = rgb2gray(imread(strcat(preDir,'nonface01.jpg')));
nonface02 = rgb2gray(imread(strcat(preDir,'nonface02.jpg')));
nonface03 = rgb2gray(imread(strcat(preDir,'nonface03.jpg')));
cartoonface01 = rgb2gray(imread(strcat(preDir,'cartoonface01.jpg')));
cartoonface02 = rgb2gray(imread(strcat(preDir,'cartoonface02.jpg')));
cartoonface03 = rgb2gray(imread(strcat(preDir,'cartoonface03.jpg')));
cartoonface04 = rgb2gray(imread(strcat(preDir,'cartoonface04.jpg')));
IMG_5888 = rgb2gray(imread([preDir 'group/IMG_5888.jpg']));
MyPic = rgb2gray(imread([preDir 'group/MyPic.jpg']));
School = rgb2gray(imread([preDir 'group/School.jpg']));

% Use the non-smiling faces as the training set 
faces = nonsmiling_cropped;
testfaces = smiling_cropped;

%%======================================================================
%% Training
% Calculate the eigenfaces
[avgface, eigfaces] = eigenfaces(faces,k );

imshow(uint8(round(avgface)))
title('Average face')
pause

for i = 1 : k    
    % We take the absolute values because the "eigs" function is
    % non-deterministic: if v is an eigenvector then sometimes (-v) is
    % chosen instead of v. Sometimes this can make the first principal
    % component completely white, which is awkward
    histeq(abs(eigfaces(:,:,i)))
    title(strcat('Eigenvector number  ',num2str(i)))
    pause    
end

% Test with a random image (face or non-face)
chosenFace = smiling_cropped{1};
if numel(size(chosenFace)) == 3       % if RGB
    chosenFace = rgb2gray(chosenFace);
end

imshow(chosenFace)
title('Test face')
pause

coeffs = project_face(avgface,eigfaces,chosenFace);
projectedFace = construct_face(avgface,eigfaces,coeffs);

imshow(uint8(round(projectedFace)))
title('Projected face')
pause
close
%mse = is_face(avgface,eigfaces, chosenFace)
% for i = 1 : 36
%     mse = is_face(avgface,eigfaces,faces{i})    
%     pause
% end

%% STEP 1: Testing recognition with cropped class images 
% Testing recognition with cropped class images (10%)
fprintf('Testing recognition with cropped smiling images\n');

user_coeffs = zeros(k,numImages);
for i = 1 : numImages
    % Project each training face onto the face space
    user_coeffs(:,i) = project_face(avgface,eigfaces,faces{i});
end
numCorrect = 0;
figure('units','normalized','outerposition',[0 0 1 1]) % Full screen 
for i = 1 : numImages
    order = recognize_face(avgface,eigfaces,user_coeffs,testfaces{i});
    if (order(1) == i)
        numCorrect = numCorrect + 1;
    else
        fprintf('Student number %d was incorrectly classified as number %d \n',i,order(1));        
        % order'
        % REMARKS : The correct results appear at the top 3 of the sorted
        % order 
        subplot(1,3,1)              
        subimage(testfaces{i});               
        title(['Test face number ' num2str(i)])
        subplot(1,3,2)        
        subimage(faces{i});
        title('Train face of corresponding student')
        subplot(1,3,3)        
        subimage(faces{order(1)});        
        title(['Incorrectly classified as number ' num2str(order(1))])
        pause
    end
end
close all
fprintf('%d / %d smiling students were correctly recognized \n\n',numCorrect, numImages);
pause


% Experiment with the number of eigenfaces used
fprintf('Experiment with number of eigenfaces\n');
idx = 3: 2: 35;
corrects = [];
%figure('units','normalized','outerposition',[0 0 1 1]) % Full screen 
figure
k = 35;
[avgface, fullEigfaces] = eigenfaces(faces,k);
for k = idx
    % Training
    k   
    %[avgface, eigfaces] = eigenfaces(faces,k );
    eigfaces = fullEigfaces(:,:,1 : k);
    % Testing
    user_coeffs = zeros(k,numImages);
    for i = 1 : numImages
        % Project each training face onto the face space
        user_coeffs(:,i) = project_face(avgface,eigfaces,faces{i});
    end
    numCorrect = 0;
    for i = 1 : numImages
        order = recognize_face(avgface,eigfaces,user_coeffs,testfaces{i});
        if (order(1) == i)
            numCorrect = numCorrect + 1;
        end
    end    
    corrects = [corrects numCorrect];        
end

plot(idx, corrects);
title('Number of correct cases')
pause
%%======================================================================
%%  STEP 2: Finding faces in an image
fprintf('Step 2: Finding faces in an image\n');
fprintf('Please wait. This should take quite a long time\n');
k = 10;
[avgface, fullEigfaces] = eigenfaces(faces,k);
scale = 1.0;
n = 3;
selectedPic = IMG_5888;
[x,y,s] = find_faces(avgface, eigfaces,selectedPic, n, scale);
draw_faces(selectedPic,x,y,s)

close all