function  fim = gauss(image, sigma)
% Gaussian filter of size (2k+1)x(2k+1) preformed on a given image

% read the image
im = imread(image);
gim = im2gray(im);
dim = im2double(gim); 

% calculate the optimal size of Gaussian filter
kernel = calcGauss(sigma);

% use it on the image
fim = imfilter(dim, kernel);
% imshow(fim, []);
