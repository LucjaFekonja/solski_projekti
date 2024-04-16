function presecisca = bentley_ottmann(tocke)
% Funkcija BENTLEY_OTTMANN sprejme tabelo točk
% tocke = [x1, x2, x3 ...; y1, y2, y3 ...],
% kjer sosednja stolpca definirata ogljišča daljice.
% Algoritem vrne vsa presečišča danih daljic razen 
% točk samih.

% tvorimo tabelo vseh daljic, kjer bosta prvi dve vrstici predstavljali x
% in y koordinato ene točke, 3. in 4. vrstica pa x in y koordinato druge
% točke
n = length(tocke(1,:));
daljice = [1:n-1; tocke(:, 1:n-1); tocke(:, 2:n)];

% uredimo daljice tako, da bodo v prvi vrstici tiste točke, ki so bolj na
% levi strani
for i = 1:n-1
    if daljice(2, i) > daljice(4, i)
        t = daljice(2:3, i);
        daljice(2:3, i) = daljice(4:5, i);
        daljice(4:5,i) = t;
    end
end

% Ustvarimo tabelo vseh eventov. To so vse točke, v katerih sweeping line
% sreča levo ali desno točko neke premice ali pa najde presečišče
leve_tc = [daljice(1,:); daljice(1:3, :)];
desne_tc = [daljice(1,:); daljice([1 4 5], :)];
eventi = [leve_tc, desne_tc];

% uredimo evente po x in y
eventi = sortrows(eventi.', [3 4]).'

% definirajmo sweeping line, ki se bo pomikal od leve proti desni in
% tabelo, kamor bomo shranjevali vsa presečišča
SL = zeros(5, 0);
presecisca = zeros(4, 0);

while ~isempty(eventi(1,:)) 
    e = eventi(:, 1);

    if stolpec_v_matriki(e, leve_tc)
        indeks_daljice = e(1,1);
        i = find(daljice(1,:) == indeks_daljice);
        daljica_e = daljice(:, i);

        % V SL shranjujemo daljice, ki sekajo navpičnico x = e_x v
        % naraščajočem vrstnem redu po y. Dodajmo daljico_e
        SL = dodaj_v_sweep_line(SL, daljica_e);

        % najdimo indeks na katerem je shranjena daljice, katere levo
        % krajišče je e in shranimo tisto daljico, ki je takoj nad njo in
        % tisto, ki je takoj pod njo
        j = find(SL(1,:) == daljica_e(1));
        if j>1
            B = SL(:, j-1);  % pod
            if preveri_presecisce(daljica_e, B)
                [~, tc] = presecisce_daljic(daljica_e, B);
                presecisce = [daljica_e(1); B(1); tc(1); tc(2)];

                if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                    eventi = [eventi, presecisce];
                end
            end
        end
        if length(SL)>1 && j ~= length(SL)
            A = SL(:, j+1);  % nad
            if preveri_presecisce(daljica_e, A)
                [~, tc] = presecisce_daljic(daljica_e, A);
                presecisce = [daljica_e(1); A(1); tc(1); tc(2)];
                
                if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                    eventi = [eventi, presecisce];
                end
            end
        end
    elseif stolpec_v_matriki(e, desne_tc)
        indeks_daljice = e(1,1);
        i = find(daljice(1,:) == indeks_daljice);
        daljica_e = daljice(:, i);

        j = find(SL(1,:) == daljica_e(1));
        if j>1 && j ~= length(SL)
            B = SL(:, j-1);  % pod
            A = SL(:, j+1);  % nad
            if preveri_presecisce(A, B)
                [~, tc] = presecisce_daljic(A, B);
                presecisce = [A(1); B(1); tc(1); tc(2)];
                if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                    eventi = [eventi, presecisce];
                end
            end
        end
        SL = odstrani_iz_sweep_line(SL, daljica_e);

    else
        presecisca = [presecisca, e];

        % e je presečišče daljic
        index_1 = e(1);
        index_2 = e(2);

        % Poiščimo daljico nad in pod prvo daljico katere e je presečišče
        j = find(SL(1,:) == index_1);
        daljica_j = daljice(:, index_1);
        i = find(SL(1,:) == index_2);
        daljica_i = daljice(:, index_2);

        if i>j
            if i ~= length(SL)
                A = SL(:, i+1);
                if preveri_presecisce(daljica_i, A)
                    [~, tc] = presecisce_daljic(daljica_i, A);
                    presecisce = [daljica_1(1); A(1); tc(1); tc(2)];
                
                    if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                        eventi = [eventi, presecisce];
                    end
                end
            end
            if j>1
                B = SL(:, j-1);  % pod
                if preveri_presecisce(daljica_j, B)
                    [~, tc] = presecisce_daljic(daljica_j, B);
                    presecisce = [daljica_j(1); B(1); tc(1); tc(2)];

                    if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                        eventi = [eventi, presecisce];
                    end
                end
            end
        elseif j>i
            if j ~= length(SL)
                A = SL(:, j+1);
                if preveri_presecisce(daljica_j, A)
                    [~, tc] = presecisce_daljic(daljica_j, A);
                    presecisce = [daljica_j(1); A(1); tc(1); tc(2)];
                
                    if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                        eventi = [eventi, presecisce];
                    end
                end
            end
            if i>1
                B = SL(:, i-1);  % pod
                if preveri_presecisce(daljica_i, B)
                    [~, tc] = presecisce_daljic(daljica_i, B);
                    presecisce = [daljica_i(1); B(1); tc(1); tc(2)];

                    if ~(ismember(presecisce(3:4), presecisca(3:4)) == ones(2,1))
                        eventi = [eventi, presecisce];
                    end
                end
            end
        end 
    end
    eventi = eventi(:, 2:length(eventi(1,:)));
end
        



