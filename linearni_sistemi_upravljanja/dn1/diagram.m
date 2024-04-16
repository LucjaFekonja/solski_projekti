function sys = diagram(K, G1, G2, H1, H2, H3)

% Sestavimo zaprtozančni sistem
block1 = feedback(G1, H2);
block2 = series(block1, G2);
block3 = feedback(block2, H1);
block4 = feedback(block3, H3);
block5 = series(block4, tf(K, [1 0]));
block6 = feedback(block5, tf(1, 1));

sys = minreal(block6);
