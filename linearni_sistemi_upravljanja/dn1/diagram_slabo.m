function f = diagram_slabo(K, G1, G2, H1, H2, H3) 
% Izračuna prenostno funkcijo za dan diagram (specifično tistega na
% spletni)
% K ... konstanta
% G1, G2, H1, H2, H3 ... izrazi v spremenljivki s

syms s
f = simplify(K * G1 * G2 / ((1 + G1 * H2 + G1 * G2 * H1 + G1 * G2 * H3) * s + K * G1 * G2));