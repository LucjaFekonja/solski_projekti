function crossings = secondary_detector(y, Fs)

% set initial value as random value from y
randx = randperm(100,1);
ET = [y(randx) zeros(1, length(y))];
i = 2;
crossing = false;
crossings = [];

% 200 ms
A = round(Fs * 0.2);

while i < length(y) 
    
    % If there is a crossing, ET is raised
    if y(i) > ET(i-1) && y(i-1) <= ET(i-1)
        crossings(end+1) = i;
        reference = i;
        crossing = true;
        if i + A > length(y)
            ET(i+1) = 4 * (0.75 * ET(i-1) + 0.5 * max(y(i:end)));
        else
            ET(i+1) = 4 * (0.75 * ET(i-1) + 0.5 * max(y(i:i+A)));
        end

        j = 1;
        % Check for the next 200 s if there is a crossing
        while j < A && i < length(y) 
            i = i + 1;

            % If there is raise ET and reset last_crossing
            % j loop goes from the beginning
            if y(i) > ET(i-1) && y(i-1) <= ET(i-1)  
                crossings(end) = i;
                reference = i;
                crossing = true;
                j = 1;
                if i + A > length(y)
                    ET(i+1) = 4 * (0.75 * ET(i-1) + 0.5 * max(y(i:end)));
                else
                    ET(i+1) = 4 * (0.75 * ET(i-1) + 0.5 * max(y(i:i+A)));
                end
                
            % Otherwise keep the ET
            else 
                ET(i+1) = ET(i);
                j = j + 1;
            end
        end

        % After 200 ms ET is lowered
        ET(i) = 0.2 * ET(i-1);
        i = i + 1;

    % If there is no detection for 1 second
    elseif crossing == true && reference < i - Fs
        ET(i) = 0.5 * ET(i-1);
        reference = i;
        i = i + 1;

    % Otherwise hold the same ET
    else 
        ET(i) = ET(i-1);
        i = i + 1;
    end
end

% plot(1:length(y), y);
% hold on;
% plot(1:length(ET), ET);
end