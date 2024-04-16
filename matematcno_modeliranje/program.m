function program(I, J, vrsta, L)
% Funkcija PROGRAM zažene enega od glavnih programov glede na podane
% parametre. 
% Če je vrsta = 0, program poišče lik, ki si zapre najprej glede na
% parametrizacijo zadnje narisane daljice.
% Če je vrsta = 1, program poišče lik, ki ima tipično večjo ploščino in
% seka samega sebe.
% L je seznam razdalj zaporednih naključnih točk. Če je podan, bo prva
% točka izbrana na območju I x J, vsaka naslednja pa na določeni razdalji.
% Če ni podan, bodo vse točke izbrane naključno na I x J.

if vrsta == 0 && ~exist('L','var')
    program1(I, J);
elseif vrsta == 0
    program2(I, J, L);
elseif vrsta == 1 && ~exist('L','var')
    program3(I, J);
else 
    program4(I, J, L);
end
