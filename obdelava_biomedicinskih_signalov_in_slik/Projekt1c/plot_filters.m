% LOW-PASS FILTER
a1 = [1/4, 1/2, 1/4];  % Koeficients at X
b1 = 1;                % Koeficients at Y
figure;
zplane(a1, b1);

% MAINS FILTER
a2 = [1, -2 * cos(60*pi / 125), 1];
b2 = 1;
figure;
zplane(a2, b2);

% DERIVATIVE FILTER
a3 = [1 0 0 0 0 0 1];
b3 = 1;
figure;
zplane(a3, b3);

% PRODUCT OF ALL FILTERS
a = [1, 2-2*cos(60*pi/125), 2-4*cos(60*pi/125), 2-2*cos(60*pi/125), 1, 0, 1, 2-2*cos(60*pi/125), 2-4*cos(60*pi/125), 2-2*cos(60*pi/125), 1];
b = 1;
figure
zplane(a, b);


x = linspace(0, 500, 1000);
y = zeros(1, 1000);
for i = 1:length(y)
    y(i) = (1 + 2*i + i^2) * (1 - 2 * cos(60*pi/125) * i + i^2) * (1 + i^6) / i^8;
end

d = [1 zeros(1, 511)];
h = filter(b, a, d);
showSpecs(h, 360)
