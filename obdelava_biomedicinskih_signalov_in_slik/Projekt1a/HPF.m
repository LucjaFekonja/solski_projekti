function y = HPF(x, M)
% HPF(x, M) is a M-point moving average filter
% x is an unfiltered signal
% M should be odd (best M=5 or M=7)

n = length(x);
    
y = zeros(1, n);
for i = 1 : n
    if i >= M
        y1 = sum(x((i-M+1) : i)) / M;
        y2 = x(i - (M+1) / 2);
        y(i) = y2 - y1;
    end
end