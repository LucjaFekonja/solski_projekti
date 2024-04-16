function bool = kolinearne_na_daljici(A, B, C)
% Funkcija KOLINEARNE_NA_DALJICI preveri, če točka B = (x2, y2) leži na
% daljici, ki povezuje točki A = (x1, x2) in C = (x3, y3).
% Predpostavljamo, da so A, B in C kolinearne

if B(1) < min(A(1), C(1))
    bool = false;
elseif B(1) > max(A(1), C(1))
    bool = false;
elseif B(2) < min(A(2), C(2))
    bool = false;
elseif B(2) > max(A(2), C(2))
    bool = false;
else
    bool = true;
end