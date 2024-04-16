function qrs = decision_maker(y, T, alpha, gamma) 
% DETECTOR(y, T, alpha, gamma) is designed for decision-making
% y ... filtered signal (put trough HPF and LPF)
% T ... adaptive threshold (could be set to peak value of first few
% samples)
% alpha ... forgetting factor (from 0.01 to 0.1)
% gamma ... weighting factor (0.15 or 0.2)

% When signal is higher than threshold overT is set to True
overT = False; 
j = 0;
i = 1;
qrs = [];

while i <= length(y)

    % QRS complex is detected if signal exceeds the threshold
    % Save the index where crossing happens
    if y(i) >= T && overT == False
        j = i;
        overT = True;

    % Detection is carried after the signal returns below threshold
    elseif y(i) < T && overT == True
        
        % Find the peak of the slice of signal that was above threshold
        [peak, l] = max(y(j : i));
        qrs(end+1) = j + l - 1;
        
        % Set a new threshold
        T = alpha * gamma * peak + (1 - alpha) * T;
        j = 0;
        overT = False;
        
    end
    i = i + 1;
end