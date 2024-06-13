function o = find_lambda(A, B, C, L, lambda)

P = [-4 -3 lambda -1];
K = acker(A, B, P);

x0 = [0 0 0 0];
opazovalec0 = [0 0 0 0];

t = linspace(0, 1, 1000);
u = [3*ones(1000, 1) zeros(1000, 1) zeros(1000, 1) zeros(1000, 1)];

sis3 = ss([A -B*K; L*C A-L*C-B*K],[B*K;B*K], [C zeros(1,4)],0);
[Y,T,X] = lsim(sis3, u, t, [x0 opazovalec0]);

o = max(abs(X(:,3)));