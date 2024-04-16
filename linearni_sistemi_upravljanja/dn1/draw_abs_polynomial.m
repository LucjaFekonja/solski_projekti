function draw_abs_polynomial(p, X)
% p ... koeficienti polinoma v padajočem vrstnem redu x^i
% X ... definicijsko območje

x = linspace(X(1), X(2), 1000);
y = sqrt(abs(polyval(p, x)));

plot(x, y)