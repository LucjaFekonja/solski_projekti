function stabilnostna_abscisa = find_tau(W, A, B, tau)

K = B' / W(tau);
A_zap = A - B * K;
l_vr = eig(A_zap);

% Naredi sistem ma dude

stabilnostna_abscisa = max(real(l_vr));