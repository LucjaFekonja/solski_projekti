% naloga 1

p = [1, 6.25, 12.5, 8.75, 1.44];
nal1a = sum(roots(p));

table = routh(p);
prvi_st = table(:, 1);
nal1b = min(prvi_st) * max(prvi_st);

q = [1, 6, 11, 6];
nal1c = find_alpha(p, q);



% naloga 2

K = 5;
C1 = tf([1 0], [1 1]);
C2 = tf(1, [1 2]);
C3 = tf(1, [1 3]);
C4 = tf(1, [1 4]);
C5 = tf([1 K], [1 1 1]);

sis2 = diagram(C1, C2, C3, C4, C5);
nal2a = pole(sis2);

t = linspace(0, 10, 1000);
nal2b = max(step(sis2, t));


f = @(K) dcgain(diagram(C1, C2, C3, C4, tf([1 K], [1 1 1]))) - 0.1;
nal2c = fzero(f, [1, 10]);

u = [ones(600, 1); zeros(200, 1); ones(600, 1); zeros(200, 1); ones(600, 1); zeros(200, 1)];
t  = linspace(0, 12, 2400);
odziv = lsim(sis2, u, t);
M = max(odziv(1600:2400));
nal2d = find(odziv == M) / 2;



% naloga 3

R = 2.04;
L = 0.21;
C1 = 0.14;
C2 = 0.11;
t = linspace(0, 1, 5000);

A = [-1/(R*C1), 0, -1/C1; 0, 0, 1/C2; 1/L, -1/L, 0];
B = [1/(R*C1); 0; 0];
C = [1, -1, 0];
D = 0;

nal3a = det(A);

sis3 = ss(A, B, C, D);
nal3b = mean(step(sis3, t));


C = [0, 0, 1];
sis4 = ss(A, B, C, D);
i_desired = (ones(1, 5000) - t)';

u1 = [ones(5000, 1)];
u2 = [zeros(2500, 1); ones(2500, 1)];

% 1. nacin
f = @(a) norm(lsim(sis4, a(1) * u1 + a(2) * u2, t) - i_desired);
fsolve(f, [1; 1])

% 2. nacin
x1 = lsim(sis4, u1, t);
x2 = lsim(sis4, u2, t);
I = [x1, x2];
koef = I \ i_desired;
nal3c = koef(1)

% :(
























