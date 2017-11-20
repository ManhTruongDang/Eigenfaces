function [avgface, eigfaces] = eigenfaces(faces,k )
% This function uses PCA to generate eigenfaces from the set of user faces
% Written by Dang Manh Truong
% Input: faces -  the set of faces in a cell array of 2xd images (example : 32x32 images) 
%      : k - the number of eigenfaces to compute
% Output: avgface - the average face (in double form)
%       : eigface - the eigen faces (in double form)

numFaces = numel(faces);

% Find the average size of all the images
avgSize = 0; 
for i = 1 : numFaces
    avgSize = avgSize + size(faces{i},1);
end
avgSize = round(avgSize / numFaces);

faceVec = zeros(avgSize * avgSize, numFaces); 
% Resize all images to the average size 
for i = 1 : numFaces     
    resizedImage = my_imresize(double(faces{i}),avgSize,avgSize);          
    faceVec(:,i) = reshape(resizedImage,[],1);    
end

% Calculate the average face
avgVec = sum(faceVec,2) ./ numFaces;
%avgface = reshape(avgVec,size(faces{1}));
avgface = reshape(avgVec, avgSize, avgSize);

% imshow(uint8(round(avgface)))
% pause

% Find the eigenfaces 
newFaces = faceVec - repmat(avgVec,1,numFaces);
newFaces = newFaces ./ numFaces;
reducedCov = newFaces' * newFaces; % L'*L instead of L*L' to save computation time

[reducedEig,D] = eigs(reducedCov,k);
[~,I] = sort(diag(D),'descend'); % Sort in descending order
reducedEig = reducedEig(:, I);
eigfaces = newFaces * reducedEig; % Get the correct eigenvectors

% Normalize the eigenfaces
for i = 1 : size(eigfaces,2)
    eigfaces(:,i) = eigfaces(:,i) ./ norm(eigfaces(:,i),2);    
end

% eigfaces(:,1)' * eigfaces(:,2)
% pause

% Reshape back to image form
eigfaces = reshape(eigfaces, avgSize, avgSize,  k);