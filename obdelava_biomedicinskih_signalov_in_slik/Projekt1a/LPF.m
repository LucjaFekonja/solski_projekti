function y = LPF(x, window)
% LPF(x, window) is a low-pass filter
% x is the output of HPF
% window is the width of the window in moving sum (best corresponding to
% 150 ms in real-time)
y = movsum(x.^2, window);