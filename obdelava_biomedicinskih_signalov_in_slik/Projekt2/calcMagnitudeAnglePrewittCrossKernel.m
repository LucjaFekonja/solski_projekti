function [mag, ang, gx, gy] = calcMagnitudeAnglePrewittCrossKernel(fslice)

kx = [-1, 0, 1; -1, 0, 1; -1, 0, 1]; % use Prewitt cross
ky = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
gx = conv2(fslice, kx, 'same'); % gradient along x axis for the whole image
gy = conv2(fslice, ky, 'same'); % gradient along y axis for the whole image

% calculate magnitute and angle for the whole image
mag = sqrt(gx.^2 + gy.^2);
ang = atan2(gy, gx);
