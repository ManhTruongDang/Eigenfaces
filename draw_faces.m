function [] = draw_faces(img,x,y,s) 

imshow(img)
numRec = size(x,1);
hRec = cell(1,numRec);
for i = 1: numRec
    hRec{i} = rectangle('Position',[y(i) x(i) s(i,2) s(i,1)], 'LineWidth',2, 'EdgeColor','b');                        
end

for i = 1: numRec
    delete(hRec{i});
end

end






