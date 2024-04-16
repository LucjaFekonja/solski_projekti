function canny24(folder, sigma, th_version)

fileList = dir(fullfile(folder, '*.png'));
fileList = {fileList.name};
edgeimages = zeros(512, 512, length(fileList));

for i = 1 : length(fileList)

    imshow(folder + "\" + fileList(i))
    fim = gauss(folder + "\" + fileList(i), sigma);
    [mag, ang, ~, ~] = calcMagnitudeAnglePrewittCrossKernel(fim);
    edge = edgethinning(mag,ang);

    if th_version == 0
        % get rid of noise % set thresholds
        sorted = sort(edge(:));
        sorted(sorted == 0) = [];
        if isempty(sorted)
            low_th = 0.5;
            up_th = 0.5;
        else
            low_th = sorted(round(length(sorted) / 5));
            up_th = sorted(round(4 * length(sorted) / 5));
        end 
        
        linked = doublethreshold(edge, low_th, up_th);
        linked(linked ~= 0) = 1;

        name = fileList{i};
        outputFileName = [folder(1:end-9), '\filtered_not_linked\', name(1:end-4), '_canny.png'];
        imwrite(linked, outputFileName);

        edgeimages(1:512, 1:512, i) = linked;

    elseif th_version == 1
        up_th = otsuthresh(imhist(edge));
        low_th = up_th / 2;

        linked = doublethreshold(edge, low_th, up_th);
        linked(linked ~= 0) = 1;
        
        name = fileList{i};
        outputFileName = [folder(1:end-9), '\improved_not_linked\', name(1:end-4), '_canny_otsu.png'];
        imwrite(linked, outputFileName);

        edgeimages(1:512, 1:512, i) = linked;
    end
end

edgeimages(:, :, end+1) = zeros(512, 512);

result = suppression24(edgeimages, folder, fileList, th_version);

figure;
for k = 1 : length(fileList)
    [~, p] = contour(result(:, :, k));
    colormap(gray);
    p.ContourZLevel = k;
    p.FaceAlpha = 0.5;
    hold on;
end
view(3);

if th_version == 0
    saveas(gcf, [folder(1 : end-8), '\3d.png']);
elseif th_version == 1
    saveas(gcf, [folder(1 : end-8), '\3d_otsu.png']);
end

