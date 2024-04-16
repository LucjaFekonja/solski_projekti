function [x, y] = low_pass_filter(x)
x1 = [0 0 x];
y = zeros(1, length(x));
for i = 1:(length(x1)-2)
    y(i) = (x1(i) + 2 * x1(i+1) + x1(i+2))/4;
end
% figure;
% plot(1:length(x), y)