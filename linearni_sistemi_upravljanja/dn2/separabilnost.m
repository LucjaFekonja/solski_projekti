function separateness = seperabilnost(A1, B2)
    % Velikost matrik
    n1 = size(A1, 1);
    n2 = size(B2, 1);
    
    % Inicializacija z naključnim vektorjem
    z = randn(n1 * n2, 1);
    
    % Nastavitve za metodo moči
    tol = 1e-6; % Toleranca za konvergenco
    max_iter = 1000; % Največje število iteracij
    prev_norm = 0;
    
    for iter = 1:max_iter
        % Uporabi funkcijo ResiDelta za novo iteracijo
        z = ResiDelta(A1, eye(n1), eye(n1), eye(n2), B2', eye(n2), z);
        
        % Normalizacija vektorja
        norm_z = norm(z);
        z = z / norm_z;
        
        % Preveri konvergenco
        if abs(norm_z - prev_norm) < tol
            break;
        end
        prev_norm = norm_z;
    end
    
    % Največja singularna vrednost je kvadratni koren največje lastne vrednosti
    separateness = sqrt(prev_norm);
end