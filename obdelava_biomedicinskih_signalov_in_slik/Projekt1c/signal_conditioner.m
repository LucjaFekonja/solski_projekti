function y = signal_conditioner(x1, x2)
% low pass filter used on both signals
[~, y1_low] = low_pass_filter(x1);
[~, y2_low] = low_pass_filter(x2);

% mains filter used on both signals
[~, y1_mains] = mains_filter(y1_low);
[~, y2_mains] = mains_filter(y2_low);

% derivative filter used on both signals
[~, y1_diff] = derivative_filter(y1_mains);
[~, y2_diff] = derivative_filter(y2_mains);

% absolute value of product of all filters
y1 = abs(y1_diff);
y2 = abs(y2_diff);

% Return the sum of both signals
y = y1 + y2;
% x = 1:length(y);

% figure;
% plot(1:length(x), y)