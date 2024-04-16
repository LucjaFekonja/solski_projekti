function filtered = adaptiveFilterKernel(image, h)

% read the image
im = imread(image);
gim = im2gray(im);
dim = im2double(gim); 

kx = [-1, 0, 1; -1, 0, 1; -1, 0, 1]; % use Prewitt cross
ky = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
gx = conv2(dim, kx, 'same'); % gradient along x axis for the whole image
gy = conv2(dim, ky, 'same'); % gradient along y axis for the whole image

d = sqrt(gx.^2 + gy.^2);
w = exp(-sqrt(d) / (2 * h^2));

slice = zeros(length(dim(:, 1)) + 2, length(dim(1, :)) + 2);
new = slice;
w_slice = slice;

slice(2 : length(dim(1, :)) + 1, 2 : length(dim(:, 1)) + 1) = dim;
w_slice(2 : length(dim(1, :)) + 1, 2 : length(dim(:, 1)) + 1) = w;

for i = 2 : length(dim(1,:))+1
    for j = 2 : length(dim(:,1))+1
        S = slice(i-1 : i+1, j-1 : j+1);
        W = w_slice(i-1 : i+1, j-1 : j+1);

        new(i, j) = sum(S(:) .* W(:));
    end
end

filtered = new(2 : end-1, 2 : end-1);