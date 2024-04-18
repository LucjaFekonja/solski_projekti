function r = aux_function_3(sis, v0, v1, v2, t, a, b, c)
[~, ~, X] = lsim(sis, a * v0 + b * v1 + c * v2, t);
r = X(:, 1);