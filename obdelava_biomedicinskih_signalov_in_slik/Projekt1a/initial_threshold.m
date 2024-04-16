function T = initial_threshold(y, seconds, alpha, gamma)

peaks = findpeaks(y(1 : seconds * 360)); % sample frequency is 360
T = zeros(1, length(peaks) + 1);

for i = 1 : length(peaks)
    T(i + 1) = alpha * gamma * peaks(i) + (1 - alpha) * T(i);
end