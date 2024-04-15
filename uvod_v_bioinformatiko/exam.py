from collections import defaultdict

def compare(s, t):
    table = defaultdict(int)
    for i, si in enumerate(s):
        for j, tj in enumerate(t):
            table[i, j] = max(
            table[i-1, j],
            table[i, j-1],
            table[i-1, j-1] + (si == tj)
            )
    return table
x = "AACCTTGG"
y = "ACACTGTGA"
table = compare(x, y)
print(table[len(x)-1, len(y)-1])

print(defaultdict(int)[])
