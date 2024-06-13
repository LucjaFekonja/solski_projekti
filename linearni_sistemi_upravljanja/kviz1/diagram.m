function sys = diagram(C1, C2, C3, C4, C5)

% Sestavimo zaprtozančni sistem
block1 = feedback(C3, C1);
block2 = parallel(C4, C5);
block3 = series(block1, C2);
block4 = feedback(block3, block2);

sys = minreal(block4);
