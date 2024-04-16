function se_sekata = preveri_presecisce(d1, d2)
% Funkcija PREVERI_PRESECISCE za daljici d1 in d2 preveri, če se sekata.
% Daljici d1 in d2 sta podani s točkama, ki ju povezujeta:
% d1 = [x1 x2; y1 y2]
% d2 = [x3 x4; y3 y4]
% OPOMBA: Bolje je uporabljati preveri_presecisce_orientacija

% parametrizirajmo daljici
x1 = @(t) d1(1, 1) * (1 - t) + d1(1, 2) * t;
y1 = @(t) d1(2, 1) * (1 - t) + d1(2, 2) * t;
x2 = @(t) d2(1, 1) * (1 - t) + d2(1, 2) * t;
y2 = @(t) d2(2, 1) * (1 - t) + d2(2, 2) * t;

% poiščimo t1 in t2, da velja x1(t1) = x2(t2) in y1(t1) = y2(t2)
eq1 = @(t1, t2) x1(t1) - x2(t2);
eq2 = @(t1, t2) y1(t1) - y2(t2);

eq12 = @(v) [eq1(v(1), v(2)); eq2(v(1), v(2))];
presek_t = fsolve(eq12, [0.5; 0.5]);

% če sta najdena t1 in t2 veljavna, izračunajmo presek
if presek_t(1) >= 0 && presek_t(1) <= 1 && presek_t(2) >= 0 && presek_t(2) <= 1
    se_sekata = true;
else
    se_sekata = false;
end
