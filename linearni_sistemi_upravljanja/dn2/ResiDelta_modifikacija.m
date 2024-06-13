function x = ResiDelta_modifikacija(A1, B2, z)
    % Velikost matrik
    n1 = size(A1, 1);
    n2 = size(B2, 1);
    Z = reshape(z, n1, n2);
    
    % Enačba Lyapunova: Z = AY - YB
    % kjer je Y = X*A' - B*X

    Y = lyap(A1, -B2, -Z);
    X = lyap(A1', -B2', -Y);
    x = reshape(X, [], 1);
    
