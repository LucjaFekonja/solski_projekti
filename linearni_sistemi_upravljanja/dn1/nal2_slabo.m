% 2. NALOGA 

syms s;
G1 = 1/(s+1);
G2 = s/(s+2);
H1 = 1/(s+3);
H2 = 3/(s+4);
H3 = (s+2)/(s+5);

% a) Za K=10 zapiši prenosno funkcijo in izračunaj njene pole
K = 10;
f = diagram_slabo(K, G1, G2, H1, H2, H3);
poles(f, s)


% b) Čas izravnave za impulzni odziv za sistem iz a)
% Iz a): f = (10*s^3 + 120*s^2 + 470*s + 600)/(s^5 + 16*s^4 + 108*s^3 + 410*s^2 + 881*s + 810)
nominator = [10, 120, 470, 600];
denominator = [1, 16, 108, 410, 881, 810];
sys = tf(nominator, denominator);

% plot
impulse(sys);
hold on
yline(0.05);
yline(-0.05);

% Izrečun iz vgrajenih - NE DELA
S = stepinfo(sys,SettlingTimeThreshold=0.05);
S.SettlingTime + S.RiseTime;


% Zadnje presečišče med response in y=0.05 oz y=-0.05
% ones_array_minus = y > -0.05;
% Najdi kje je subarray [0 1] z malo poskušanja
% index = strfind(ones_array_minus(1.5 * 1e+10:end).', [0 1])
% ones_array_plus = y < 0.01;
% ones_indices_plus = find(ones_array_plus == 1);
% max(find(ones_indices_plus(2:end) - ones_indices_plus(1:end-1) ~= 1))
% Settling time
% tOut(1.5 * 1e+10 + index)



% c) Izračunajte, kakšna mora biti konstanta K∈[10,20], da bo limita 
% stopničnega odziva, ko gre t proti neskončnosti, enaka 0.8. Pri tem 
% si pomagajte s funkcijo dcgain(sis) in fzero za iskanje ničle ustrezne 
% kriterijske funkcije. 

% syms K;
% g = 1 / (1 - (K * G1 * G2 / ((1 + G1 * H2 + G1 * G2 * H1 + G1 * G2 * H3) * s + K * G1 * G2)));

% findK = limit(g, s, 0) - 0.8;
% Display: findK = - 1/(K/(2*(K/2 + 7/4)) - 1) - 4/5

% K = fzero(@(K) - 1/(K/(2*(K/2 + 7/4)) - 1) - 4/5, 15)


syms K;
sys2 = diagram(K, G1, G2, H1, H2, H3);
Kp = dcgain(sys2);
