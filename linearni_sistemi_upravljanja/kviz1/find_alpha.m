function alpha = find_alpha(p, q)
% Find such alpha that p-aq has a non-negative real zero

n = length(p);
m = length(q);

if n > m
    poly = @(a) p - a * [zeros(1, n-m), q];
elseif n < m
    poly = @(a) [zeros(1, m-n), p] - a * q;
else
    poly = @(a) p - a * q;
end

f = @(a) max(roots(poly(a)));
alpha = fzero(f, 10);             % Izberi približek!