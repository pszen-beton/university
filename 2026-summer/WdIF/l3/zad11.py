import numpy as np

loan_amount = 5e4

i = 0.07

loan_amount_11 = 5e4 * (1 + i) ** 11

payments = np.array([5e3 for _ in range(5)] + [5e3 * (1 + 0.1) ** k for k in range(1,6)])

factors = np.array([(1 + i) ** (11-k) for k in range(1,11)])

payments_11 = payments * factors

left_to_pay = loan_amount_11 - sum(payments_11)

print(left_to_pay)
