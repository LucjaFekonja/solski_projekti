function tocke = daljica(T1, T2)
% Funkcija DALJICA nariše daljico, ki povezuje T1 in T2 in vrne tabelo 100
% točk, ki ležijo na tej daljici

n = 100;
tocke = zeros(2, n);

tocke(1, :) = linspace(T1(1), T2(1), n);
tocke(2, :) = linspace(T1(2), T2(2), n);

plot(tocke(1,:), tocke(2,:));