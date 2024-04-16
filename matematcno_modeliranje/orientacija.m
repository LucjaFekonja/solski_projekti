function o = orientacija(A, B, C)
% Funkcija ORIENTACIJA vrne 0, če so točke A, B in C kolinearne, 1, če so
% orientirane v negativni smeri (smer urinega kazalca) in -1, če so 
% orientirane v pozitivni.

o = (B(2) - A(2)) * (C(1) - B(1)) - (C(2) - B(2)) * (B(1) - A(1));

if o > 0
    o = 1;
elseif o < 0
    o = -1;
else
    o = 0;
end
