function program4(I, J, L)
% Funkcija PROGRAM4 deluje isto kot program3, le da naključne točke riše na
% razdaljah podanih v seznamu L

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
            plot(presecisca(3,:), presecisca(4,:), "x", 'Color', "b");

            % označujmo premice, ki jih p_n seka s q_1 ... q_k, kjer p_n
            % najprej seka q_1, nato q_2 ...

            % če je presečišče samo eno, vemo, da so ogljišča naslednja
            % tudi če je q_1 enak zadnji narisani premici p_1 izmed q_1
            % ... q_k, poznamo ogljišča lika
            if length(presecisca(1, :)) == 1 
                lik = [tocke(:, k+1:n-1), presecisca(3:4, 1)];
                ploscina = polyarea(lik(1,:), lik(2,:));
                break;
            end

            % Če je presečišč več, preverimo, če je bila prva, ki jo p_n
            % seka narisana pred ali za zadnjo, saj potem dodajamo točke v
            % obratnem vrstnem redu.
            len = length(presecisca(1,:));
            ploscina = 0;

            % Med ogljišča dodajmo prvo najdeno presečišče
            lik = [presecisca(3:4,1)];
            s_prva = presecisca(1,1);
            s_zadnja = presecisca(1,len);

            % Poiščimo daljico, ki jo p_n seka in je bila med q_1 ... q_k
            % dodana nazanje. Torej tisto z največjim indeksom.
            [s_max, s] = max(presecisca(1,:));

            % Tvorimo lik, ki vsebuje presečišče med p_{s_max} in p_n ter
            % točke (x_{s_max + 1}, y_{s_max + 1}) ... (x_{n-1}, y_{n-1})
            lik2 = [presecisca(3:4, s) tocke(:, s_max + 1 : n-1)];
            ploscina = ploscina + polyarea(lik2(1,:), lik2(2,:));

            % Obarajmo ta lik
            siva = [0.7 0.7 0.7];
            fill(lik2(1,:), lik2(2,:), siva);

            if presecisca(1,1) < presecisca(1, len)

                % Za vsak par zaporednih presečišč z daljicama p_s in p_t
                % dodamo točke (x_s+1, y_s+1) ... (t_t, y_t)
                for j = 2:len
                    t = presecisca(1, j);

                    % Če je bila naslednje p_t dodana kasneje kot p_s,
                    % dodamo točke 
                    if t > s_prva && t <= s_zadnja

                        % Točk med (x_s+1, y_s+1) ... (t_t, y_t), ki ležijo
                        % znotraj lik2 ne dodamo med ogljišča
                        in = inpolygon(tocke(1, s_prva+1:t), tocke(2, s_prva+1:t), lik2(1,:), lik2(2,:));
                        x_izb = tocke(1, s_prva+1:t);
                        y_izb = tocke(2, s_prva+1:t);

                        % Točke, ki niso znotraj lik2:
                        izb_tocke = [x_izb(~in); y_izb(~in)];

                        % Tvorimo lik
                        %lik = [lik tocke(:, s_prva+1:t) presecisca(3:4, j)];
                        lik = [lik izb_tocke presecisca(3:4, j)];

                        pomozen = [lik(:, length(lik(1,:))) tocke(:, s_prva+1:t) presecisca(3:4, j)];
                        ploscina = ploscina + polyarea(pomozen(1,:), pomozen(2,:));
                    end
                    s_prva = t;
                end
                break;

            else
                for j = 2:len

                    % Za vsak par zaporednih presečišč z daljicama p_s in p_t
                    % dodamo točke (x_s, y_s) ... (x_t+1, y_t+1), torej v
                    % obratnem vrstnem redu kot prej
                    t = presecisca(1, j);

                    if t < s_prva && t >= s_zadnja

                        % Točk med (x_s+1, y_s+1) ... (t_t, y_t), ki ležijo
                        % znotraj lik2 ne dodamo med ogljišča
                        in = inpolygon(tocke(1, s_prva:-1:t+1), tocke(2, s_prva:-1:t+1), lik2(1,:), lik2(2,:));
                        x_izb = tocke(1, s_prva:-1:t+1);
                        y_izb = tocke(2, s_prva:-1:t+1);

                        % Točke, ki niso znotraj lik2:
                        izb_tocke = [x_izb(~in); y_izb(~in)];
                    
                        lik = [lik izb_tocke presecisca(3:4, j)];
                        %lik = [lik tocke(:, s_prva:-1:t+1) presecisca(3:4, j)];

                        pomozen = [lik(:, length(lik(1,:))) tocke(:, s_prva:-1:t+1) presecisca(3:4, j)];
                        ploscina = ploscina + polyarea(pomozen(1,:), pomozen(2,:));

                    end
                    s_prva = t;
                end
                break;
            end
        end
    end
end

% obarvajmo lik
siva = [0.7 0.7 0.7];
fill(lik(1,:), lik(2,:), siva);
alpha(0.5);  % spremenimo opaznost osenčenega lika

% izračunajmo še ploščino lika
%ploscina = polyarea(lik(1, :), lik(2,:));
fprintf("Ploščina obarvanega lika je %s. \n", ploscina);

hold off;