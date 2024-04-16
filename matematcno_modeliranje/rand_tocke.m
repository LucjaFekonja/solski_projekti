function [tocka_x, tocka_y] = rand_tocke(I, J)
% Funkcija RAND_TOCKE izbira naključne točke iz območja IxJ.
% Naj bo I interval na x-os, J pa na y-osi. Točke bo potem probram izbiral
% iz območja I x J.
I_min = I(1);
I_max = I(2);
J_min = J(1);
J_max = J(2);

% rand izbira točke med 0 in 1. Če želimo naključno vrednost na intervalu,
% to naredimo z raztegom in translacijo
tocka_x = (I_max - I_min) * rand(1,1) + I_min;
tocka_y = (J_max - J_min) * rand(1,1) + J_min;

plot(tocka_x, tocka_y, 'o', 'Color', 'r');