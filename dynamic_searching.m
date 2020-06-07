function center = dynamic_searching(mid,data,range)
%         range = 10;
        % search the new centroid within 10 by 10 pixels around the center 
        
        %%% might need to flip the 1st and 2nd position of mid
        temp = data(mid(2)- range: mid(2) + range, mid(1)- range: mid(1) + range);
        Ibw = imfill(temp,'holes');
        
        Ilabel = bwlabel(Ibw);
        s = regionprops(Ilabel,'centroid');
        centroid = cat(1, s.Centroid);
        % a n by 2 matrix, each row is a centroid
        if (isempty(centroid))
            center = [];
        else
            % each element will be unique
            center = round(centroid) + mid - range;
        end
        
end

