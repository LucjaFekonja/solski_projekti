function x = ResiDelta(A1,B1,C1,A2,B2,C2,z)

n1 = size(A1, 1);
n2 = size(A2, 1);
Z = reshape(z, n2, n1);

nov_z = C2 * Z *  A1' - A2 * Z * C1';

% nova enačba : C2 * x * B1' - B2 * x * C1' = nov_z
%               B2^-1 * C2 * x - x * C1' * B1'^-1 = B2^-1 * nov_z * B1'^-1
%               L * x - x * D = Q

L = B2 \ C2;
D = C1' / B1';
auxQ = B2 \ nov_z;
Q = auxQ / B1';

x = lyap(L, -D, -Q);
x = reshape(x, [], 1);