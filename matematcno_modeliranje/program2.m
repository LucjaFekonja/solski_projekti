function program2(I, J, L)
% Funkcija PROGRAM2 izbere prvo točko na območju I x J, vsako nadaljno pa
% na predpisani razdalji od prejšnje. Razdalje naj bodo podane v seznamu L.
% Nato program deluje enako kot program1.

axis equal;

% Določimo območje, na katerem lahko program izbere prvo točko
%I = [0, 10];
%J = [0, 10];

% Določimo dolžine daljic, ki jih bo program generiral. Več kot jih bo,
% večja je verjetnost, da najdemo samopresečišče
%L = [1 1 1 1 1 1 1 1 1];

% števec za število premic, ki smo jih narisali
n = 1;
se_sekata = false;

% pripravimo array, kamor bomo shranjevali točke poligona, ki ga
% generiramo
tocke = zeros(2, 1);

% dodajmo prvo točko
[prva_tocka_x, prva_tocka_y] = rand_tocke(I, J);
tocke(:, n) = [prva_tocka_x; prva_tocka_y];
hold on;

while se_sekata == false
    n = n + 1;

    if n - 1 > length(L)
        fprintf('Najdeno ni bilo nobeno presečišče.');
        break;
    end

    % dodajmo naslednjo točko 
    [tocka_x, tocka_y] = rand_tocka_na_dolzini(tocke(:, n-1), L(n-1));
    tocke(:, n) = [tocka_x; tocka_y];

    % narišimo daljico, ki povezuje novo dodano točko s prejšnjo
    daljica(tocke(:, n-1), tocke(:, n)); % = tocke_na_daljici
    hold on;
    pause(0.2);

    % preverimo, ali nova daljica seka katero od prejšnjih daljic, razen
    % ene pred njo, t. j. (n-1)-ve
    for i = 2:n-2
        % zadnja dodana daljica povezuje točki
        p_n = tocke(:, n-1:n);
        % i-ta dodana daljica povezuje točki
        p_i = tocke(:, i-1:i);

        se_sekata = preveri_presecisce_orientacija(p_n, p_i);

        % če smo našli presečišče izračunamo vsa presečišča z zadnjo dodano
        % premico p_n
        if se_sekata == true

            % Tabela vseh presečišč p_n z ostalimi premicami vključno s
            % parametrom t, pri katerem ima p_n(t) presečišče, in s
            % številko premice p_j, ki p_n seka
            presecisca = zeros(4, 0);

            % presečišča moramo preveriti zgolj s premicami p_1...p_i, saj
            % vemo, da s premicami p_i+1 ... p_n-2 p_n nima skupne točke
            l = 0;
            for j = 2:n-2
                p_j = tocke(:, j-1:j);

                % v tabelo presečišča shranimo vse najdene točke, ki
                % ustrezajo pogoju
                if preveri_presecisce_orientacija(p_n, p_j) == true
                    l = l + 1;
                    [presek_t, presek] = presecisce_daljic(p_n, p_j);
                    presecisca(:, l) = [j-1; presek_t(1); presek(1); presek(2)];
                    k = j-1;
                end
            end

            % sedaj ločimo dve možnosti: obstaja eno presečišče in obstaja
            % več presečišč

            % Uredimo jih po naraščajočem t
            presecisca = sortrows(presecisca.', 2).';

            % označujmo premice, ki jih p_n seka s q_1 ... q_k, kjer p_n
            % najprej seka q_1, nato q_2 ...

            % če je presečišče samo eno, vemo, da so ogljišča naslednja
            % tudi če je q_1 enak zadnji narisani premici p_1 izmed q_1
            % ... q_k, poznamo ogljišča lika
            if length(presecisca(1, :)) == 1 %|| presecisca(1,1) == max(presecisca(1,:))
                plot(presecisca(3,1), presecisca(4,1), "x", 'Color', "b");
                lik = [tocke(:, k+1:n-1), presecisca(3:4, 1)];
                break;
            end

            % Če je bila premica, ki jo seka pn najprej, narisana najkasneje
            if presecisca(1,1) == max(presecisca(1,:))
                plot(presecisca(3,1), presecisca(4,1), "x", 'Color', "b");
                lik = [tocke(:, k+1:n-1), presecisca(3:4, 1)];
                break;
            end

            % če je q_1 enak prvi narisani premici p_1, q_2 enak zadnji
            % narisani premici izmed q_1 ... q_k, poznamo ogljišča lika
            if presecisca(1, 1) == min(presecisca(1,  :)) && presecisca(1, 2) == max(presecisca(1,  :))
                plot(presecisca(3,2), presecisca(4,2), "x", 'Color', "b");
                lik_test = [tocke(:, k+1:n-1), presecisca(3:4, 2)];

                [in, on] = inpolygon(tocke(1,:), tocke(2,:), lik_test(1,:), lik_test(2,:));
                % nobena od točk, razen prve, ne leži znotraj lika
                m = min(presecisca(1,  :));
                if all(in(2:length(tocke)-m) - on(2:length(tocke)-m) == 0, 2)
                    lik = lik_test;
                    break;
                end
            end

            % sicer pa za vsak par premic q_m in q_m+1, m=1...k-1, kjer naj
            % bo q_m = p_s in q_m+1 = p_t, preverimo ali katera od p_s+1
            % ... p_t-1 seka zadnjo narisano premico p_n
            for m = 1:length(presecisca(1,:))-1
                s = min(presecisca(1, m), presecisca(1, m+1));
                t = max(presecisca(1, m), presecisca(1, m+1));
                if all(ismember(s+1:t-1, presecisca(1,:)) == 0, 2)
                    lik = [tocke(:, t:-1:s+1), presecisca(3:4, m:m+1)];
                    break;
                end
                
            % če katera od teh premic seka p_n, moramo postopek
            % ponoviti za q_m+1 in q_m+2
            % postopek se konča, saj je poligon zvezen
            end
            break;
         
        end
    end
end

% obarvajmo lik
siva = [0.7 0.7 0.7];
fill(lik(1,:), lik(2,:), siva);
alpha(0.5);  % spremenimo opaznost osenčenega lika

% izračunajmo še ploščino lika
ploscina = polyarea(lik(1, :), lik(2,:));
fprintf("Ploščina obarvanega lika je %s. \n", ploscina);

hold off;