function r = routh(p)

n = length(p);

% First two rows
r1 = p(1:2:end);
if mod(n, 2) == 0 
    r2 = p(2:2:end);
else 
    r2 = [p(2:2:end), 0];
end

% Initialize the Routh table
r = [r1; r2; zeros(n-2, n / 2 + mod(n, 2))];

% Iterate to complete the table
for k = 3 : n
    r(k, :) = [r(k-2, 2:end) - r(k-2, 1) / r(k-1, 1) * r(k-1, 2:end), 0];
end