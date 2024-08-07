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
alpha = find_alpha(p, q);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
impulse(sis);
hold on
yline(0.02);
yline(-0.02);

% Right click -> characteristics -> transient time


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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3. NALOGA

% Sistem:
% i' = - R/L * i - 1/L * w + 1/L * v
% w' = 1/C * i

% x = [i; w]
% y = [i; w]

R = 2;
L = 0.2;
C = 0.15;

A = [-R/L, -1/L; 1/C, 0];
B = [1/L; 0];
C = [1 0; 0 1];
D = [0; 0] ;

% Sistem spremljamo v prvih 10 časovnih enotah, razdeljenega na 5000 točk
t = linspace(0, 10, 5000);
sis3 = ss(A, B, C, D);


% a) Povprečna vrednost toka (x(:,1)) na prvih 10s, če je vhod v = enotska stopnica
x = lsim(sis3, ones(5000, 1), t);
povprecje_i = mean(x(:,1));


% b) Pri katerem k je jakost izhodnega signala w ravno 10% vrednsti
% vhodnega signala v

f2 = @(k) aux_2(sis3, k);
k = fzero(f2, 10);



% c) Najdi alpha

% Definicija enotskih signalov
v1 = [ones(5000, 1)];
v2 = linspace(0, 10, 5000)';

x0 = impulse(sis3, t);
x1 = lsim(sis3, v1, t);
x2 = lsim(sis3, v2, t);
I = [x0(:, 1) x1(:, 1) x2(:, 1)];


% Definicija toka, ki ga želimo doseči
i_desired = 0.1 * ones(5000, 1);

% Izračun koeficientov α, β in γ z metodo najmanjših kvadratov
coefficients = lsqr(I, i_desired);

% Izpis koeficientov
% alpha = coefficients(1)
% beta = coefficients(2)
% gamma = coefficients(3)
















