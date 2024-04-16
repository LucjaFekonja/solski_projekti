function [x, y] = mains_filter(x)
x1 = [0 0 x];
y = zeros(1, length(x));
for i = 1:(length(x1)-2)
    y(i) = x1(i) - 2 * cos(60*pi/120) * x1(i+1) + x1(i+2);
end
% figure;
% plot(1:length(x), y);