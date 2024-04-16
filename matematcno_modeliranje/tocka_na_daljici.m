function [x, y] = tocka_na_daljici(t1, t2, a)
% Funkcija TOCKA_NA_DALJICI poišče točko, ki leži na daljici, ki povezuje
% točki t1 = (x1, y1) in t2 = (x2, y2), ko je x koordinata enaka a

    x = a;

    % Poiščimo pri katerem t je je x = a
    x1 = @(t) t1(1) * (1 - t) + t2(1) * t - a;
    t = fzero(x1, 0.5);

    % y koordinata je torej enaka
    y1 = @(t) t1(2) * (1 - t) + t2(2) * t;
    y = y1(t);