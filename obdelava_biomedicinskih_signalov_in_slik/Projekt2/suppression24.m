function result = suppression24(edgeimages, folder, fileList, th_version)

M = length(edgeimages(1, 1, :));
result = zeros(512, 512, M-1);

for n = 1 : M - 1
    new  = zeros(516, 516);
    edgeimage1  = zeros(516, 516);
    edgeimage1(3:514, 3:514) = edgeimages(:, :, n);
    edgeimage2  = zeros(516, 516);
    edgeimage2(3:514, 3:514) = edgeimages(:, :, n+1);


    for i = 3 : 514
        for j = 3 : 514

            % STEP 1
            if edgeimage1(i, j) == 1

                % STEP 2
                if not(edgeimage2(i, j) == 1)
                    
                    % STEP 3
                    slice3x3 = edgeimage2(i-1:i+1, j-1:j+1);
                    if not(any(any(slice3x3 == 1) == 1))

                        % STEP 4
                        slice5x5 = edgeimage2(i-2:i+2, j-2:j+2);
                        if not(all(all(slice5x5 == 0) == 1))

                            % STEP 5
                            for k = -2 : 2
                                for l = -2 : 2
                                    if slice5x5(k + 3, l + 3) == 1

                                        a = k;
                                        b = l;
                                        while a ~= 0 && b ~= 0
                                            new(i+a, j+b) = 1;

                                            if a < 0
                                                a = a + 1;
                                            elseif a > 0
                                                a = a - 1;
                                            end

                                            if b < 0
                                                b = b + 1;
                                            elseif b > 0
                                                b = b - 1;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    % sum(new(:) == 1)   % number of added ones
    % image = new(3:514, 3:514) + edgeimages(:, :, n);
    
    image = edgeimages(:, :, n);
    image = new(3:514, 3:514) + image;
    image(image ~= 0) = 1;
    result(:, :, n) = image;
    imshow(image, [])

    name = fileList{n};

    if th_version == 0
        outputFileName = fullfile([folder(1:end-9), '\filtered\'], [name(1:end-4), '_canny.png']);
        imwrite(image, outputFileName);

    elseif th_version == 1
        outputFileName = [folder(1:end-9), '\improved\', name(1:end-4), '_canny_otsu.png'];
        imwrite(image, outputFileName);
    end  
end