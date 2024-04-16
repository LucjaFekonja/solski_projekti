% 1.  y'' + 5y' + 3y = u'' + 8u'+ 5u
%  a) Vnesi sistem v Matlab v obliki s prenosno funkcijo (uporabi funkcijo tf).

numerator = [1, 8, 5];
denominator = [1, 5, 3];
sys1 = tf(numerator, denominator)

% b) Zapiši predstavitev sistema v spoznavnostni kanonični obliki.

A = [-5, 1; -3, 0]; 
B = [8; 5] - 1 * [5; 3];
C = [1, 0];
D = 1;
sys2 = ss(A , B, C, D);
tf(sys2);


% c) Zapiši predstavitev sistema v vodljivostni normalni obliki.

A = [0, 1; -3, -5];
B = [0; 1];
C = [5, 8] - 1 * [3, 5];
D = 1;
sys3 = ss(A, B, C, D);
tf(sys3)

% d)
sys4 = ss(sys1);
tf(sys4)



% 2. Dan je sistem
%    x' = [0 1 0; 0 0 1; -3, -2, -5] + [0; 0; 1] * u
%    y = [1 0 0] * x

% a) Določi prenosno funkcijo Y(s)/U(s) s pomočjo funkcije tf.

A = [0 1 0; 0 0 1; -3, -2, -5];
B = [0; 0; 1];
C = [1 0 0];
D = 0;
sys5 = ss(A, B, C, D);
tf(sys5)


% b) Nariši ničelni odziv sistema pri začetnem stanju x(0) = [ 0 −1 1 ]T za 0 ≤ t ≤ 10.

x0 = [0; -1; 1];

% initial(sys5, x0)   % ukaz za ničelni odziv u=0 sistema (x'=Ax, y=Cx)
% lsim               % Nariši

% Drugi način:
t = linspace(0, 10, 2000);
[~, ~, X] = initial(sys5, x0, t)
lsim(sys5, 0*t, t, x0)


% c) Izračunaj prehodno matriko za t = 10 s pomočjo funkcije expm in izračunaj x(t) s pomočjo
%    prehodne matrike iz začetnega stanja iz točke b).

% Spomni se: x(t) = exp^(At) * x0 + integral_{0}^{t}(exp^( A*(t - tau) * B * u(tau) )dtau
%
% Nevsiljen sistem: exp^(At) * x0
% Ničelno začetno stanje: integral_{0}^{t}(exp^( A*(t - tau) * B * u(tau) )dtau

% Za naš primer moramo izračunati samo x(t) = exp^(At) * x0 
%                                      y(t) = c * x(t)

% V Matlabu: exp^(At) = expm(A * t) za t=10
expm(A * 10) * x0

% Drugi način: Zanima nas zadnja vrstica matrike X:
X(end, :)



% 3. Izberite primerno vrednost za parameter b, ki regulira dušenje, da bo vzmetenje dobro absorbiralo
%    tako a) visoke grbine pri velikih hitrostih kot tudi b) majhne grbine pri majhnih hitrostih. Pri
%    tem si lahko a) predstavljate kot impulzno funkcijo, b) pa kot enotsko stopnico. Enačbi, ki
%    opisujeta spreminjanje y in q sta
%       m * y'' + k2 * y + k1 * (y - q) = f
%       -b * q'+ k1 * (y-q) = f
%    Sistem predstavite v prostoru stanj in za vrednosti vzemite k1 = 2, k2 = 1 in m = 1

% 1. način:
%   x1 = y
%   x2 = y' 
%   x3 = q

%   x1' = x2
%   x2' = 1/m * (f - k2 * x1 - k1 ...)
%   x3 = 1/b * (k1 * (x1 - x3) - f)

%   x' = [0 1 0; (k2 - k1)/m  0  k1/m; k1/b 0 -k1/b] * x + [0; 1/m; -1/b] * u
%   y = [1 0 0] * x

for 








