%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. naloga

A = [-10.0 8.0 -5.0 1.0; 8.0 -9.0 -6.0 1.0; 1.0 10.0 -7.0 1.0; -4.4 -2.0 0.0 -4.0]; 
B = [1.0; -1.0; -5.0; 2.0]; 
C = [1.0 0.0 0.0 0.0]; 
D = 0;
x0 = [1 0 -4.1 0];

sis1 = ss(A, B, C, 0);

t = linspace(0, 3, 10000);
u = cos(t) ./ (5*t + 1);
y = lsim(sis1, u, t, x0);
nal11 = t(find(y < 1e-16, 1));

% -------------------------------------------------------------------------

A2 = A + 6 * eye(size(A,1));

integrand = @(s) expm(-A2 * s) * (B * B') * expm(-A2' * s);
W = @(tau) integral(integrand, 0, tau, 'ArrayValued', true);

K = B' / W(1);
sis2 = ss(A2-B*K, B, C, D);

nal12 = max(real(pole(sis2)));

% -------------------------------------------------------------------------

l_vr = eig(A2);
beta = 12;

L = A2 + beta * eye(size(A2, 1));
Q = 2 * B * B';

Z = lyap(L, L, -Q);
K = B' / Z;

nal13 = det(A2 - B * K);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. naloga

n1 = 3; 
n2 = 2; 
A1 = -4.9*eye(n1) + magic(n1); 
B1 = 5*eye(n1) + ones(n1) + magic(n1)/2; 
C1 = 3*eye(n1) + ones(n1); 
A2 = -4.6*eye(n2) + magic(n2)/3; 
B2 = 2*eye(n2) - ones(n2) + magic(n2)/5; 
C2 = -4.5*eye(n2) - ones(n2); 
z = (1:n1*n2)';

x = ResiDelta(A1, B1, C1, A2, B2, C2, z);
nal21 = norm(x);

% -------------------------------------------------------------------------

n1 = 250; 
n2 = 300; 
A1 = -4.9*eye(n1) + magic(n1); 
B1 = 5*eye(n1) + ones(n1) + magic(n1)/2; 
C1 = 3*eye(n1) + ones(n1); 
A2 = -4.6*eye(n2) + magic(n2)/3; 
B2 = 2*eye(n2) - ones(n2) + magic(n2)/5; 
C2 = -4.5*eye(n2) - ones(n2); 
z = (1:n1*n2)';

L = B2 \ C2;

Z = reshape(z, n2, n1);
nov_z = C2 * Z *  A1' - A2 * Z * C1';
auxQ = B2 \ nov_z;
Q = auxQ / B1';

norm1A = norm(L, 1);
norm1C = norm(Q, 1);

nal22 = norm1A / norm1C;

% -------------------------------------------------------------------------

GammaFun = @(v) ResiDelta(A1, B1, C1, A2, B2, C2, v);
nal23 = eigs(GammaFun, n1 * n2, 1, "smallestabs");

% -------------------------------------------------------------------------

n1 = 25; 
n2 = 30; 
A1 = -4.9*eye(n1) + magic(n1); 
B2 = 2*eye(n2) - ones(n2) + magic(n2)/5; 

f = @(v) ResiDelta_modifikacija(A1, B2, v);
max_lvr = max(eigs(f, n1 * n2, 1, "largestabs"));
nal24 = sqrt(max_lvr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. naloga

A = [0 1 0 0; 0 0 -1 0; 0 0 0 1; 0 0 100.1100 0]; 
B = [0 ; 0.1031; 0; -0.9430]; 
C = [1 0 0 0]; 
D = 0; 

P = [-4 -3 -2 -1];
K = acker(A, B, P);
nal31 = norm(K,1);

% -------------------------------------------------------------------------

P = [-20-10i, -20+10i, -12, -12];
L_transpose = acker(A', C', P);
L = L_transpose';

sis3 = ss([A -B*K; L*C A-L*C-B*K],[B*K;B*K], [C zeros(1,4)],0);

Co = ctrb(sis3);
nal32 = norm(Co);


% -------------------------------------------------------------------------

t = linspace(0, 1, 1000);
u = [3*ones(1000, 1) zeros(1000, 1) zeros(1000, 1) zeros(1000, 1)];

x0 = [0 0 0 0];
opazovalec0 = [1 1 1 1];

[Y,T,X] = lsim(sis3, u, t, [x0 opazovalec0]);
nal33 = X(end, 3) - X(end, 7);


% -------------------------------------------------------------------------

f = @(lambda) find_lambda(A, B, C, L, lambda) - 0.1;
nal34 = fzero(f, -2)



























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. naloga