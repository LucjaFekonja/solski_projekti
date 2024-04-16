folder = "Patient-000302-01\2";
fileList = dir(fullfile(folder, '*.png'));
fileList = {fileList.name};

edgeimages = zeros(512, 512, length(fileList));

for i = 1 : length(fileList)
    fim = gauss(folder + "\" + fileList(i), 2.5);
    [mag, ang, gx, gy] = calcMagnitudeAnglePrewittCrossKernel(fim);
    edge = edgethinning(mag,ang);

    sorted = sort(edge(:));
    sorted(sorted == 0) = [];
    low_th = sorted(round(length(sorted) / 3));
    up_th = sorted(round(2 * length(sorted) / 3));
    
    linked = doublethreshold(edge, low_th, up_th);
    edgeimages(1:512, 1:512, i) = linked;
end

suppression24(edgeimages)