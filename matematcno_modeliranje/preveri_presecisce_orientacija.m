function se_sekata = preveri_presecisce_orientacija(d1, d2)
% Funkcija PREVERI_PRESECISCE_ORIENTACIJA s pomočjo orientacije in 
% koreliranosti preveri ali se dve daljici sekata in vrne logično vrednost.

% d1 povezuje točki p1 in p2
p1 = d1(:, 1);
p2 = d1(:, 2);
% d2 povezuje točki t1 in t2
t1 = d2(:, 1);
t2 = d2(:, 2);

% Določimo orientacijo
o1 = orientacija(p1, p2, t1);
o2 = orientacija(p1, p2, t2);
o3 = orientacija(t1, t2, p1);
o4 = orientacija(t1, t2, p2);

% Daljici se sekata, če se orientaciji ne ujemata
if o1 ~= o2 && o3 ~= o4
    se_sekata = true;
% če so p1, p2 in t1 kolinearne in t2 leži na d1
elseif o1 == 0 && kolinearne_na_daljici(p1, t1, p2)
    se_sekata = true;
% če so p1, p2 in t2 kolinearne in t1 leži na d1
elseif o2 == 0 && kolinearne_na_daljici(p1, t2, p2)
    se_sekata = true;
% če so t1, t2 in p1 kolinearne in p2 leži na d2
elseif o1 == 0 && kolinearne_na_daljici(t1, p1, t2)
    se_sekata = true;
% če so t1, t2 in p2 kolinearne in p1 leži na d2
elseif o1 == 0 && kolinearne_na_daljici(t1, p2, t2)
    se_sekata = true;
else
    se_sekata = false;
end