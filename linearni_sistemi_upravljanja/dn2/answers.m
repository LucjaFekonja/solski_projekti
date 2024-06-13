% 1. naloga 
A = [-10 8 -5; 8 -9 -6; 1 10 -7];
B = [1; -1; 2];
C = [1 0 0];
D = 0;

% Dan je sistem x' = Ax + Bu, y = Cx z začetnim stanjem x(0) = [1 0 2] in
% vhodom u(t) = sin(t)


% a) Določi najmanjši t iz [0, 1], kjer je y(t) = 0 
sis1 = ss(A, B, C, D);

% Začetno stanje
x0 = [1 0 2];

% Vhod
t = linspace(0, 1, 10000);   % Če bo potrebna večja natančnost, zvišaj 10000
u = sin(t);

% Odziv sistema na u
[y, t, x] = lsim(sis1, u, t, x0);

% Najmanjši t, da y(t) = 0
nal11 = t(find(y < 1e-16, 1));


% b) Določi beta med -5 in 5 v začetnem stanju x0 = [1 beta 2], da bo
% y(0.8) = 0

f = @(beta) find_beta(sis1, beta);
nal12 = fzero(f, -3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2. naloga
% Dan je sistem x' = Ax + Bu, y = Cx.
% Za stabilizacijo s povratno zvezo u = -Kx uporabimo matriko 
% W(tau) = integral_0^tau (expm(-A * s) * (B * B') * expm(-A' * s)) ds in 
% K = B' * W(tau)^-1

A = [4 -2 -4; -1 5 -5; 7 -3 1];
B = [1; -1; 2];
C = [1 0 0];

% a) Za stabilizacijo uporabi X(3) in izračunaj stabilnostno absciso A-BK

% Deiniraj W
integrand = @(s) expm(-A * s) * (B * B') * expm(-A' * s);
W = @(tau) integral(integrand, 0, tau, 'ArrayValued', true);

% Izračunaj feedback gain K
K = B' / W(3);

% Izračunaj matriko zaprtozančnega sistema
A_zap = A - B * K;

% Lastne vrednosti
eig_values = eig(A_zap);

% Stabilnostna abscisa (maksimalni realni del lastnih vrednosti)
nal21 = max(real(eig_values));

% ljubček NIK
% sis = ss(a-B*K, B, C, D);
% max(real(pole(sis))); je odgovor


% b) Določi vrednost tau med (1, 5), pri katerem je stabilnostna abscisa
% A-BK enaka -1.4 pri izbiri K = B' * W(tau)^-1

g = @(tau) find_tau(W, A, B, tau) + 1.4;
nal22 = fzero(g, 5);


% c) Za stabilizacijo sistema uporabite K = B' * Z^(-1), kjer je Z rešitev
% enačbe Ljapunova (A + beta * I) Z + Z (A + beta * I)' = 2BB', in mora za
% beta > 0 veljati, da je večji od absolutne vrednosti vsake lastne
% vrednosti matrike A z negativnim realnim delom. Za beta vzemite
% najmanjše tako celo število. 

% Kolikšna je razdalja najbolj oddaljene lastne vrednosti matrike A-BK 
% od izhodišča?

% Preglej lastne vrednosti A in izračunaj absolutne vrednosti tistih, ki
% imajo negativen realni del
l_vr = eig(A);

% Nobena nima negativnega Re -> Vzemimo beta = 1
beta = 1;

% Reši enačbo Ljapunova
Z = lyap(A + beta * eye(size(A)), - 2 * B * B');

% Izračunaj K
K = B' / Z;

% Izračunaj najbolj oddaljeno lastno vrednost A-BK od izhodišča
nal23 = max(abs(eig(A - B * K)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3. naloga

% a) Izpiši po absolutni vrednosti največji element vektorja x
n1 = 2; 
n2 = 3; 
A1 = 10*eye(n1) + magic(n1); 
B1 = 5*eye(n1) + ones(n1) + magic(n1)/2; 
C1 = 3*eye(n1) + ones(n1); 
A2 = 3*eye(n2) + magic(n2)/3; 
B2 = 2*eye(n2) - ones(n2) + magic(n2)/5; 
C2 = 1*eye(n2) - ones(n2); 
z = (1:n1*n2)';
%Z = reshape(z, n2, n1);

x = ResiDelta(A1, B1, C1, A2, B2, C2, z);
nal31 = max(x);


% b) Izpiši po absolutni vrednosti največji element vektorja x
n1 = 200; 
n2 = 300; 
A1 = 10*eye(n1) + magic(n1); 
B1 = 5*eye(n1) + ones(n1) + magic(n1)/2; 
C1 = 3*eye(n1) + ones(n1); 
A2 = 3*eye(n2) + magic(n2)/3; 
B2 = 2*eye(n2) - ones(n2) + magic(n2)/5; 
C2 = 1*eye(n2) - ones(n2); 
z = (1:n1*n2)';
%Z = reshape(z, n2, n1);

x = ResiDelta(A1, B1, C1, A2, B2, C2, z);
nal32 = max(x);


% c) 
GammaFun = @(v) ResiDelta(A1, B1, C1, A2, B2, C2, v);
nal33 = max(abs(eigs(GammaFun, n1 * n2, 1, "largestabs")));


% d)
n1 = 20; 
n2 = 30; 
A1 = 10*eye(n1) + magic(n1); 
B2 = 2*eye(n2) - ones(n2) + magic(n2)/5; 

f = @(v) ResiDelta_modifikacija(A1, B2, v);
max_lvr = max(eigs(f, n1 * n2, 1, "largestabs"));
nal34 = sqrt(max_lvr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4. naloga
A = [0 1 0 0; 0 0 -1 0; 0 0 0 1; 0 0 100 0]; 
B = [0 ; 0.1020; 0; -0.9448]; 
C = [1 0 0 0]; 
D = 0;


% a) 
P = [-4+3i, -4-3i, -0.4-0.3i, -0.4+0.3i];
K = acker(A, B, P);
nal41 = norm(K);

% b)
% sistem
sis4 = ss(A-B*K, B, C, D);
y = initial(sis4, [0 0 0.05 0]);
nal42 = max(abs(y));

% c) 
P = [-7+2i, -7-2i, -6+3i, -6-3i];
L_transpose = acker(A', C', P);
L = L_transpose';
nal43 = norm(L);

% d) 
sis5 = ss([A -B*K; L*C A-L*C-B*K], [B*K;B*K], [C zeros(1,4)],D);
t = linspace(0, 12, 1000);
u = [ones(1000, 1) zeros(1000, 1) zeros(1000, 1) zeros(1000, 1)];
x0 = [0 0 0.05 0];
opazovalec0 = [0 0 0 0];
[Y,T,X] = lsim(sis5, u, t, [x0 opazovalec0]);
nal44 = max(abs(X(:, 3)));











