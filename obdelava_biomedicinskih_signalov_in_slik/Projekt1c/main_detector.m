function all_crossings = main_detector(y, Fs)

% Baseline and detection threshold
randx = randperm(100,1);
BT = [y(randx) zeros(1, length(y))];
DT = [y(randx) zeros(1, length(y))];

% Stepping through the signal and saving crossings
i = 2;
crossings = [];
all_crossings = [];

% 180 ms
A = round(Fs * 0.18);

% Critical times 180ms and 360ms
criticalTime1 = A;
criticalTime2 = 2 * A;


while i < length(y)
    
    % Check if there is a crossing
    if y(i) > DT(i-1) && y(i-1) <= DT(i-1)
        crossings(end+1) = i;

        criticalTime1 = A;
        criticalTime2 = 2 * A;
    end

    % Delete all the crossings that are further than 180 ms 
    % behind
    indicesToRemove = crossings < (i - A);
    crossings(indicesToRemove) = [];

    % If there is noise change DT and BT
    if length(crossings) > 4 
        BT(i) = 1.5 * BT(i-1);
        if i - A > 0
            DT(i) = max(0.5 * max(y(i-A:i)), BT(i));
        else 
            DT(i) = max(0.5 * max(y(1:i)), BT(i));
        end

    % If second critical time is reached
    elseif criticalTime2 == 0
        BT(i) = 0.5 * BT(i-1);
        DT(i) = max(0.75 * DT(i-1), BT(i));
        criticalTime2 = 2 * A;
        criticalTime1 = A;

    % If first critical time is reached
    elseif criticalTime1 == 0
        BT(i) = 0.5 * BT(i-1);
        DT(i) = BT(i);
        criticalTime1 = A;

    % If QRS complex is detected
    elseif length(crossings) > 1 && length(crossings) <= 4
        if i - A > 0
            BT(i) = 0.75 * BT(i-1) + 0.25 * max(y(i-A:i));
            DT(i) = max(0.5 * max(y(i-A:i)), BT(i));
        else 
            BT(i) = 0.75 * BT(i-1) + 0.25 * max(y(1:i));
            DT(i) = max(0.5 * max(y(1:i)), BT(i));
        end 

        c = crossings(1);
        if not(ismember(c, all_crossings)) && not(any(abs(all_crossings - c) <= A))
            all_crossings(end + 1) = c;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    elseif length(crossings) == 1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else 
        BT(i) = BT(i-1);
        DT(i) = DT(i-1);
    end
    
    i = i + 1;
    criticalTime1 = criticalTime1 - 1;
    criticalTime2 = criticalTime2 - 1;
end

% figure;
% plot(1:length(y), y);
% hold on
% plot(1 : length(DT), DT);
% hold on
% plot(1 : length(BT), BT);

end