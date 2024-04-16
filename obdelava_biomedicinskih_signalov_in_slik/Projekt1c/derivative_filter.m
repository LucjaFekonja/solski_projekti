function [x, y] = derivative_filter(x)
x1 = [0 0 0 0 0 0 x];
y = zeros(1, length(x));
for i = 1:(length(x1)-6)
    y(i) = x1(i) - x1(i+6);
end
% figure;
% plot(1:length(x), y);