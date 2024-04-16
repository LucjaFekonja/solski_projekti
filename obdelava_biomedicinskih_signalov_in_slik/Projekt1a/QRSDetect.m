function qrs = QRSDetect(filename)
% QRSDETECT(filename) returns indexes where QRS complex was detected in a
% given signal
% filename should be 100, s20011...

signal = load(filename);
x = signal.val(1,:);

% First use the high-pass filter
M = 5;
y = HPF(x, M);

% Use low-pass filter on filtered signal
window = 360 * 0.15;
y = LPF(y, window);

% Set initial threshold level
% Use peak values of first 10 seconds of the signal
alpha = 0.05;
gamma = 0.15;
T = initial_threshold(y, 10, alpha, gamma);
T = T(end);

% Save deteted QRS complexes
qrs = decision_maker(y, T, alpha, gamma);