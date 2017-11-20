function coeffs = project_face(avgface,eigfaces,newface) 
% This function projects a new face onto the "face space" spanned by the
% eigenfaces previously computed , in order to generate a vector of
% "k" coefficients, one for each of the "k" eigenfaces
% Written by Dang Manh Truong
% Inputs: avgface - The average face (in image form - double, not uint8)
%       : eigfaces - The set of eigenfaces (in image form - double, not
%         uint8)
%       : newface - A new face that we need to project onto the "face
%         space" (in image form, uint8)
% Outputs: coeffs - A column vector of coefficients

% No matter what kind of image we are dealing with, the number of principal
% components is always at the end of the "size"
numComponents = size(eigfaces, numel(size(eigfaces)) ); 

% Resize the new face to be of the same size as the average face
avgSize = size(avgface,1);
newface =  double(my_imresize(double(newface),avgSize,avgSize));

% Vectorize the eigenfaces and the new face
newface = reshape(newface,[],1);

eigfaces = reshape(eigfaces,[], numComponents);
avgface = reshape(avgface,[],1);

% Calculate the coefficients by projecting them onto the "face space"
% spanned by the eigenfaces
coeffs = eigfaces' * (newface - avgface);

end

