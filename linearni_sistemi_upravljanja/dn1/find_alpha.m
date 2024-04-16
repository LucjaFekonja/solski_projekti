function poly = find_alpha(p, q)
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


for a = 0:1e-7:1
    if max(roots(poly(a))) > 0
        a
        break;
    end
end
