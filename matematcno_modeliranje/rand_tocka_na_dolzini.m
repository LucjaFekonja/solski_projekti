function [x, y] = rand_tocka_na_dolzini(tc, L)
% Funkcija TOCKA_NA_DOLZINI vrne naključno točko, ki je od dane točke tc
% oddaljena za L

% Izberimo poljubno vrednost kota med 0 in 2*pi in izračunajmo točko z
% uporabo polarne parametrizacije.
fi = 2 * pi* rand(1, 1);
x = tc(1) + L * cos(fi);
y = tc(2) + L * sin(fi);
    
plot(x, y, 'o', 'Color', 'r');