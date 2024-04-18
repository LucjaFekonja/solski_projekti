%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
k = fzero(f2, 18);



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
alpha = coefficients(1);
beta = coefficients(2);
gamma = coefficients(3);




