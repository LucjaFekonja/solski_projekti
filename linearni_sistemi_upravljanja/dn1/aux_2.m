function r = aux_2(sis, k)

t = linspace(0, 10, 5000);
v = cos(k*t);
max_v = max(v);

y = lsim(sis, v, t);
w = y(:, 2);
max_w = max(w(2500:end));


r = 0.1 * max_v - max_w;
