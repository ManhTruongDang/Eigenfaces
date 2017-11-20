function result =test_overlap(x1,y1, height1, width1, x2, y2, height2, width2)
% Utility function to test if 2 images overlap
% Written by Dang Manh Truong
    if (x1 < x2 + height2) && (x1 + height1 > x2) && (y1 < y2 + width2) && (y1 + width1 > y2)
        result = true;
    else
        result = false;
    end
end

