function canny(image, param, th_version)
% param ... sigma if using gauss filter, h if using adaprive filter
% filterVersion ... 0 for gauss, 1 for adaptive filter

% let's filter the image 
imshow(image)
fim = gauss(image, param);

% calculate magnitude and angle
[mag, ang, ~, ~] = calcMagnitudeAnglePrewittCrossKernel(fim);

% show thin edges
edge = edgethinning(mag,ang, fim);

if th_version == 0
    % get rid of noise % set thresholds
    sorted = sort(edge(:));
    sorted(sorted == 0) = [];
    low_th = sorted(round(length(sorted) / 5));
    up_th = sorted(round(4 * length(sorted) / 5));

    result = doublethreshold(edge, low_th, up_th);
    result(result ~= 0) = 1;
    
    figure;
    imshow(result, [0, 1]);
    imwrite(result, [image(1:end-4), '_canny.png']);

elseif th_version == 1
    up_th = otsuthresh(imhist(edge));
    low_th = up_th / 2;

    result = doublethreshold(edge, low_th, up_th);
    result(result ~= 0) = 1;
    
    figure;
    imshow(result, [0, 1]);
    imwrite(result, [image(1:end-4), '_canny_otsu.png']);

end