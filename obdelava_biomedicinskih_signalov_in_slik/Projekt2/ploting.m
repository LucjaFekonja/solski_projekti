im = imread('0001.png');

%figure;
%imshow(shape, []);

% figure;
% subplot(1,3,1); gauss('Lenna.png', 0.2);
% subplot(1,3,2); gauss('Lenna.png', 1);
% subplot(1,3,3); gauss('Lenna.png', 3);

% let's filter the image with sigma=1.4
figure;
fim = gauss(['0001.png'], 1.4);

% calculate magnitude and angle
[mag, ang, gx, gy] = calcMagnitudeAnglePrewittCrossKernel(fim);

% show the original and both directional gradients
figure;
subplot(1,2,1); imshow(gx,[min(gx(:)),max(gx(:))]);
subplot(1,2,2); imshow(gy,[min(gy(:)),max(gy(:))]);

% show magnitute and angle of the whole image
figure;
%subplot(1,2,1); 
imshow(mag,[min(mag(:)),max(mag(:))]);
%subplot(1,2,2); imshow(ang,[min(ang(:)),max(ang(:))]);

% show thin edges
figure;
edge = edgethinning(mag,ang);

% get rid of noise
% set thresholds
sorted = sort(edge(:));
sorted(sorted == 0) = [];
low_th = sorted(round(length(sorted) / 5));
up_th = sorted(round(4 * length(sorted) / 5));

figure;
result = doublethreshold(edge, low_th, up_th);