function mse = is_face(avgface,eigfaces,face)
% This function decides (via a continuous value) whether or not an image is a face
% It works by projecting the potential face onto face space and computing
% the mean squared error (MSE) between the projection and the original
% Written by Dang Manh Truong
% Input: self-explanatory
% Output: mse - Mean squared error between the face and its projection onto
% the face space

coeffs = project_face(avgface,eigfaces,face);
projectedFace = construct_face(avgface,eigfaces,coeffs);

% Resize to fit the average face
avgSize = size(avgface,1);
if (size(face) == size(avgface))
    resizedFace = double(face);
else
    resizedFace = my_imresize(double(face),avgSize,avgSize);
end

% Calculate the mean-squared error
diff = resizedFace - projectedFace;
mse = norm(diff(:))^2 / (numel(diff) );

end

