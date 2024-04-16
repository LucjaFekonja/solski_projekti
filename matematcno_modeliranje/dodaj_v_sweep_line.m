function izhod = dodaj_v_sweep_line(SL, daljica)
% Funkcija DODAJ_V_SWEEP_LINE v array SL doda levo krajišče daljice
% definirane z indeksom i in s četverko točk (x1; y1; x2; y2).
% SL je potem array s podatki, ki hrani podatke o indeksu daljice, ter
% točkah, ki jih ta daljica povezuje.
% SL je nato urejena naraščajoče po y koordinati

n = length(SL(1,:));

% Če je SL prazen, daljico zgolj dodamo
if n == 0
    izhod = daljica;
    return
end

% Koordinati krajišča
x1 = daljica(2, 1);
y1 = daljica(3, 1);

% Funkcija, ki izračuna točko na daljici d pri x = x1
y = @(d) y_koo(d(2:3, :), d(4:5, :), x1);

y_min = y(SL(:,1));
y_max = y(SL(:, n));

% Če je y koordinata vhodne daljice pri x = x1 manjša od najmanjše
% koordinate y v točki x = x1 vseh daljic v SL, daljico dodamo na začčetek
if y1 < y_min
    izhod = [daljica, SL];
% Če je večja, pa na konec
elseif y1 >= y_max 
    izhod = [SL, daljica];
else
    % Sicer poiščemo tisti dve daljici, da je y1 ravno med njunima y
    % koordinatama v x = x1
    for i = 1 : n-1
        y_l = y(SL(:, i));
        y_d = y(SL(:, i + 1));

        if y1 < y_d && y1 >= y_l
            izhod = [ SL(:, 1:i), daljica, SL(:, i+1:n)];
        end
    end
end

end

function y = y_koo(t1, t2, a)
    [~, y] = tocka_na_daljici(t1, t2, a);
end