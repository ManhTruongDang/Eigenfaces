function face = construct_face(avgface,eigfaces,coeffs)
% This function constructs a face from a vector of coefficients
% Written by Dang Manh Truong
% Input: avgface - The average face (in image form - double, not uint8)
%      : eigfaces - The set of eigenfaces (in image form - double, not
%        uint8)
%      : coeffs - A column vector of coefficients
% Output: face - The newly constructed face

% No matter what kind of image we are dealing with, the number of principal
% components is always at the end of the "size"
numComponents = size(eigfaces,numel(size(eigfaces)));

face = reshape(avgface,[],1) + reshape(eigfaces,[],numComponents) * coeffs;
face = reshape(face, size(avgface));

end

