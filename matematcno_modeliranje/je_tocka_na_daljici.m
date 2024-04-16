function r = je_tocka_na_daljici(x1, y1, x2, y2, x3, y3)
    % funkcija JE_TOCKA_NA_DALJICI preveri, če točka (x3, y3) leži na premici,
    % skozi točki (x1, y1) in (x2, y2).
    
    % Premica je oblike y = k * x + n
    k = (y2-y1)/(x2-x1);
    n = y1 - k*x1;
    % Točka (x3, y3) leži na krivuljim če zadošča pogoju y3 = k * x3 + n
    yy3 = k*x3 + n;
    if y3 == yy3
        r = true;
    else
        r = false;
    end