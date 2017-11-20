function mse = compare_faces(avgface,eigfaces,face1,face2) 
% This function decides (via a continuous value) whether or not two 
% face images are of the same person.  It works by computing the MSE 
% between coefficients computed from the two images
% Written by Dang Manh Truong
% Input : The average face, the list of eigenfaces and 2 faces for
% comparison
% Output: The mean-squared error 

% Compute the projection of the 2 faces
coeffs1 = project_face(avgface,eigfaces,face1);
coeffs2 = project_face(avgface,eigfaces,face2);

% Calculate the mean-squared error
diff = coeffs1 - coeffs2;
mse = norm(diff(:))^2 / (numel(diff) );
end

