function [x y s] = find_faces(avgface,eigfaces,img,n,scales) 
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% Output : x - height coordinate 
%        : y - widht coordinate
%        : s - size of the window, for example [2 5]

imHeight = size(img,1);
imWidth = size(img,2);
scales = scales(:);

imshow(img);

x = inf(n + 1,1);
y = inf(n + 1,1);
s = inf(n + 1,2);
% Since we need only n best faces, we store the information in a list of
% of (n + 1) elements. With each window the mean-squared error (MSE) is 
% inserted into the list using insertion sort. The (n+1) element is used
% to simplify the process
listLen = 0; 
%mseList = cell(1,n + 1);
mseList = inf(n+1,1);
for m = 1 : numel(scales)
    windowHeight = round(size(avgface,1) * scales(m));
    windowWidth = round(size(avgface,2) * scales(m));
    limitHeight = imHeight - windowHeight + 1;
    limitWidth = imWidth - windowWidth + 1;   
    
    for i = 1 : imHeight
        for j = 1 : imWidth 
            
            % Check if window is within image border
            if (i <= limitHeight) &&(j <= limitWidth)                 
                %hRec = rectangle('Position',[j i windowWidth windowHeight], 'LineWidth',2, 'EdgeColor','b');                
                
                window = double(img(i : i + windowHeight - 1, j: j + windowWidth - 1));
                
                % Calculate the mean-squared error of the windowed image
                
                diff = compare_faces(avgface, eigfaces, window, avgface);                
                mse= is_face(avgface,eigfaces,window) ;                
                mse = (mse * diff) / var(window(:));
                                
                % Here comes the sorting part
                % First we put in the new element
                mseList(listLen + 1) = mse;
                x(listLen + 1) = i;
                y(listLen + 1) = j;
                s(listLen + 1,1) = windowHeight;
                s(listLen + 1,2) = windowWidth;
                
                % Remove overlapping windows and keep only the smaller one
                for counter = 1 : listLen
                    if test_overlap(x(listLen+1),y(listLen + 1), s(listLen + 1,1), s(listLen+1,2), ...
                            x(counter), y(counter), s(counter,1), s(counter,2)) == true
                        if mseList(counter) < mseList(listLen + 1)
                            mseList(listLen + 1) = inf;
                            break;
                        else
                            mseList(counter) = inf;
                        end                               
                        
                    end
                end                
                
                [mseList, idx] = sort(mseList);
                x = x(idx);
                y = y(idx);
                s(:,1) = s(idx,1);
                s(:,2) = s(idx,2);
%                 if (listLen < n)                    
%                     listLen = listLen + 1;
%                 end
                %listLen = find(mseList == inf, 1) - 1;
                listLen = find(mseList == inf,1);
                if isempty(listLen)
                    listLen = n;
                else
                    listLen = listLen - 1;
                end            
                
%                 hRec1 = cell(1,listLen);
%                 for counter = 1: listLen
%                     hRec1{i} = rectangle('Position',[y(counter) x(counter) s(counter,2) s(counter,1)], 'LineWidth',2, 'EdgeColor','g');                
%                 end
%                 pause(0.01)
%                 for counter = 1: listLen
%                     delete(hRec1{i});
%                 end
                
%                 for counter = 1:listLen
%                     delete(hRec{i});
%                 end
%                 % Insert into list using insertion sort
%                 if listLen <= n  
%                     % Keep inserting
%                     listLen = listLen + 1;
%                 else 
%                     % We "pretend" that there are (n + 1) elements, the last 
%                     % one acts as a placeholder for incoming elements in
%                     % order to keep the n elements of the list                 
%                 end
%                 jj = listLen;
%                 ii = jj - 1;
%                 key = mseCurrent;
%                 while (ii > 0) && (mseList(ii) > key)
%                     mseList(ii + 1) = mseList(ii);
%                     x(ii + 1) = x(ii);
%                     y(ii + 1) = y(ii);
%                     s(ii + 1,1) = s(ii,1);
%                     s(ii + 1,2) = s(ii,2);
%                     
%                     ii = ii -1;
%                 end
%                 mseList(ii + 1) = key;
%                 
                
                %pause(0.0001)
                %delete(hRec);
                %clearvars window
            end
        end
        
    end
end

x(n+1) = [];
y(n+1) = [];
s(n+1,:) = [];

end

