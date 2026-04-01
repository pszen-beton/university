import numpy as np

n = 20
P0 = 500
g = 0.02
i = 0.05

payments = np.array([P0 * (1 + g) ** k for k in range(n)])

v = 1 / (1 + i)

discount_factors = np.array([v ** k for k in range(1, n + 1)])

PV = sum(discount_factors * payments)
print(PV)