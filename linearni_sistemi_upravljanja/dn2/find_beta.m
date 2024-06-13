function y_t = find_beta(sis, beta)

x0 = [1, beta, 2];

t = linspace(0, 1, 10000);
u = sin(t);
y = lsim(sis, u, t, x0);

y_t = y(8000);