% 1. NALOGA

% p=x5 + 14.1 x4 + 72.4 x3 + 161.1 x2 + 135.4 x + 12

p = [1, 14.1, 72.4, 161.1, 135.4, 12];

% a) Narišite polinom p in iz slike preverite, da ima 5 negativnih ničel.
% draw_polynomial(p, [-10, 5]);
% figure;
% draw_abs_polynomial(p, [-10, 5]);

% Kolikšna je največja ničla?
nicle = roots(p);


% b) Izračunajte Routhovo tabelo. Koliko je vsota elementov prvega in drugega stolpca tabele?
r = routh(p);
vsota = sum(r(:, 1)) + sum(r(:, 2));

% c) Poišči najmanjši a, da niso vse ničle p-a*q negativne
q = [1, 14, 71, 154, 120];
% find_alpha(p, q)



% 2. NALOGA
% G1=1/(s+1),G2=s/(s+2),H1=1/(s+3),H2=3/(s+4),H3=(s+2)/(s+5).

% a) Izračunaj diagram in največji realni pol
G1 = tf(1, [1 1]);
G2 = tf([1 0], [1 2]);
H1 = tf(1, [1 3]);
H2 = tf(3, [1 4]);
H3 = tf([1 2], [1 5]);

sis = diagram(10, G1, G2, H1, H2, H3);
poli = pole(sis);


% b) Čas izravnave za sistem iz a)
[y, tOut] = impulse(sis);

info = stepinfo(y, tOut, 'SettlingTimeThreshold', 0.05);
settling_time = info.SettlingTime;

info2 = lsiminfo(y, tOut);
cas_izravnave = info2.SettlingTime;

% plot
% impulse(sys);
% hold on
% yline(0.05);
% yline(-0.05);


% c) Izračunaj K, da bo limita stolpičnega odziva, ko gre t proti inf,
% enaka 0.8.

f = @(K) dcgain(diagram(K, G1, G2, H1, H2, H3)) - 0.8 ;
fzero(f, [10, 20]);


% d) Vzemite vhodno funkcijo u=cos(5t)e−t. Izračunajte K∈[1,10], 
% da bo maksimalna vrednost odziva ravno 0.1

t = 0:0.01:3;
u = cos(5*t) .* exp(-t);
g = @(K) lsiminfo(lsim(diagram(K, G1, G2, H1, H2, H3),u,t), t).Max - 0.1;
fzero(g, [1, 10]);



% 3. NALOGA

% Sistem:
% i' = - R/L * i - 1/L * w + 1/L * v
% w' = 1/C * i

% x = [i; w]
% y = i

R = 2;
L = 0.2;
C = 0.15;

A = [-R/L, -1/L; 1/C, 0];
B = [1/L; 0];
C = [1 0];
D = 0;

% Sistem spremljamo v prvih 10 časovnih enotah, razdeljenega na 5000 točk
t = linspace(0, 10, 5000);
sis3 = ss(A, B, C, D);


% a) Povprečna vrednost toka (x(:,1)) na prvih 10s, če je vhod v = enotska stopnica
[y,tOut,x] = lsim(sis3, heaviside(t), t);
mean(x(:,1));


% b) Pri katerem k je jakost izhodnega signala w ravno 10% vrednsti
% vhodnega signala v

% v = cos(kt)
k = 0.5; % Naključna vrednost
t = linspace(5, 10, 2500);
v = cos(k*t);

[y, tOut, x] = lsim(sis3, v, t);
max_w = max(abs(x(:, 2)));


% Iskanje k, pri katerem je jakost izhodnega signala w ravno 10% jakosti vhodnega signala v
% k_values = linspace(0, 10, 10000);
% w_percent = zeros(size(k_values));
% for i = 1:length(k_values)
%     k = k_values(i);
%     v = cos(k*t);
%     [y, tOut, x] = lsim(sis3, v, t);
%     w_percent(i) = max(abs(x(:, 2))) / max(abs(v));
% end

% Najdenje k, pri katerem je w 10% vhodnega signala
% idx = find(w_percent == 0.1);
% k_values(idx);



% c) Najdi alpha
% Definicija enotskih signalov
v0 = [1; zeros(4999, 1)];
v1 = [ones(5000, 1)];
v2 = linspace(0, 1, 5000)';

% Definicija matrike vhodov
V = [v0 v1 v2];

% Definicija toka, ki ga želimo doseči
i_desired = 0.1 * ones(5000, 1);

% Izračun koeficientov α, β in γ z metodo najmanjših kvadratov
coefficients = lsqr(V, i_desired);

% Izpis koeficientov
alpha = coefficients(1)
beta = coefficients(2)
gamma = coefficients(3)
fprintf('Koeficienti: alpha = %.4f, beta = %.4f, gamma = %.4f\n', alpha, beta, gamma);

















