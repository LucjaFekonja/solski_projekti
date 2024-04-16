function bool = stolpec_v_matriki(st, mat)
% Funkcija STOLPEC_V_MATRIKI preveri, če se dan stolpec st ujema s katerim
% koli stolpcom v matriki mat

bool = false;

for i = 1:length(mat(1,:))
    % Če najdemo, da se dan stolpec ujema z i-tim stolpcem matrike, vrnemo
    % true in zaključimo
    if isequal(st, mat(:,i))
        bool = true;
        break
    end
end
