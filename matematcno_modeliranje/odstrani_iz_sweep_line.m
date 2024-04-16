function izhod = odstrani_iz_sweep_line(SL, daljica)
% Funkcija ODSTRANI_IZ_SWEEP_LINE v seznamu SL poišče stolpec, ki ustreza 
% vhodni daljici, in da izbriše. Vrne novo tabelo SL.
    n = length(SL(1,:));
    i = find(SL(1,:) == daljica(1));
    izhod = [SL(:, 1:i-1), SL(:, i+1:n)];