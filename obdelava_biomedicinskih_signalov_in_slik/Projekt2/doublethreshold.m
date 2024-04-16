function new = doublethreshold(edgeimage, low_th, up_th)

new = edgeimage;
new(new <= low_th) = 0;
new(new >= up_th) = 1;
[m, n] = size(edgeimage);

for i = 2:m-1
    for j = 2:n-1
        if new(i,j) > low_th && new(i,j) < up_th

            % check if there is a strong neighbouring pixle 
            slice = edgeimage(i-1:i+1, j-1:j+1);
            
            if not(any(any(slice == 1) == 1))
                % if not, supress
                new(i,j) = 0;
            else
                new(i,j) = 1;
            end
        end
    end
end

% imshow(new, [0, 1]);