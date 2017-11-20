function order = recognize_face(avgface,eigfaces,user_coeffs,face) 
% This function sorts a set of users (each represented by a set of
% k coefficients) by closeness to a new face,under MSE(mean-squared error)
% Written by Dang Manh Truong
% Input : avgface - the average face
%       : eigfaces - the list of eigenfaces, size "avgSize" x "avgSize" x
%       "k" where "avgSize" is the size of the average face (assumed to be
%       square) and "k" is the number of the eigenfaces
%       : user_coeffs - a matrix of user coefficients, size "k" x "number of
%       user faces", where "k" is the number of eigenfaces. Each column is a
%       series of "k" coefficients of the projected user face
%       : face - a new face that we need to recognize
% Output: order - a list of indices into the set of users, sorted in 
%       decreasing order of similarity to the new face, size
%       "number of of user faces" x 1

assert(size(eigfaces, numel(size(eigfaces))) == size(user_coeffs,1),...
    'The number of rows in user_coeffs must equals the number of eigenfaces')

% k = size(user_coeffs,1); % Number of eigenfaces
numUsers = size(user_coeffs,2); % Number of user faces
mseList = zeros(numUsers,1); 

for i = 1: numUsers    
    userFace = construct_face(avgface,eigfaces,user_coeffs(:,i));    
    mseList(i) = compare_faces(avgface,eigfaces,face,userFace);
end
[~,order] = sort(mseList,'ascend');

end

