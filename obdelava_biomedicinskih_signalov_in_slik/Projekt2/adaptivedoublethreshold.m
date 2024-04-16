function new = adaptivedoublethreshold(edgeimage)

[m, n] = size(edgeimage);
new = zeros(m + 20, n + 20);
new(11 : m + 10, 11 : n + 10) = edgeimage;
reference = new;

for i = 12:m+10
    for j = 12:n+10
        slice = reference(i-10:i+10, j-10:j+10);
        sorted = sort(slice(:));
        sorted(sorted == 0) = [];
        d = length(sorted);
    
        if d == 0
            continue;
        else
            low_th = sorted(ceil(0.12 * d));
            up_th = sorted(ceil(0.88 * d));

            roi = new(i-10:i+10, j-10:j+10);
            roi(roi <= low_th) = 0;
            roi(roi >= up_th) = 1;

            new(i-10:i+10, j-10:j+10) = roi;
        end
    end
end

new = new(11:m+10, 11:n+10);

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