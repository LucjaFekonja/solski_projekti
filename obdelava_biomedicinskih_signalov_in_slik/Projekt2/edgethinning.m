function edges = edgethinning(mag, ang, image)

% angle matrix has negative elements. Add pi to those
whereNegative = ang;
whereNegative(whereNegative>0) = 0;
whereNegative(whereNegative<0) = 1;

ang = ang + whereNegative * pi;

[m, n] = size(mag);
edges = zeros(m, n);
for i = 2:m-1
    for j = 2:n-1
        
        % if angle is rounded to 0°
        if (ang(i,j) >= 0 && ang(i,j) <= 22.5/180 * pi) || (ang(i,j) > 157.5/180 * pi && ang(i,j) <= pi)
            % point is considered to be an edge if its magnitude is greater
            % than magnitudes of pixles left and right of it
            if mag(i,j) >= mag(i,j-1) && mag(i,j) >= mag(i,j+1)
                edges(i, j) = mag(i,j);
            end

        % if angle is rounded to 90°
        elseif (ang(i,j) >= 67.5/180 * pi && ang(i,j) < 112.5/180 * pi)
            % point is considered to be an edge if its magnitude is greater
            % than magnitudes of pixles up and down of it
            if mag(i,j) >= mag(i-1,j) && mag(i,j) > mag(i+1,j)
                edges(i, j) = mag(i,j);
            end

        % if angle is rounded to 135°
        elseif (ang(i,j) >= 112.5/180 * pi && ang(i,j) < 157.5/180 * pi)
            % point is considered to be an edge if its magnitude is greater
            % than magnitudes of pixles upper-left and lower-right of it
            if mag(i,j) >= mag(i-1,j+1) && mag(i,j) >= mag(i+1,j-1)
                edges(i, j) = mag(i,j);
            end

        % if angle is rounded to 45°
        elseif (ang(i,j) >= 22.5/180 * pi && ang(i,j) < 67.5/180 * pi)
            % point is considered to be an edge if its magnitude is greater
            % than magnitudes of pixles lower-left and upper-right of it
            if mag(i,j) >= mag(i+1,j+1) && mag(i,j) >= mag(i-1,j-1)
                edges(i, j) = mag(i,j);
            end

        end            
    end
end

% imshow(edges, [0 1]);