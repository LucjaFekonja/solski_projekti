function y = energy_collector(x, Fs)

A = round(Fs * 0.08);
x1 = [zeros(1, A) x];
y = zeros(1, length(x));
for i = 1:(length(y))
    y(i) = sum(x1(i:i+A)) / A;
end
% figure;
% plot(1:length(x), y);
end