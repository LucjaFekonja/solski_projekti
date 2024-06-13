import math

A = [2, 3, 4, 6]
x = A[0]
y = A[1]
for i in range(2,4):
    z = int(abs(x*y) / (math.gcd(x,y)))
    x = z
    y = A[i]
    print(z)

print(math)