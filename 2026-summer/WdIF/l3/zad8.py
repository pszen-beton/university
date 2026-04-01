import numpy as np
import matplotlib.pyplot as plt

def exotic(n, i=0.05):
    ts = np.arange(1, 2 * n)
    rates = np.exp(-i * ts)
    values = np.array([k/n for k in range(1, n+1)] +
                      [round(1-k/n, 2) for k in range(1, n)])

    return sum((rates * values))

ns = np.arange(1, 5001)
values = []
for n in ns:
    values.append(exotic(n, 0.01))

max_val = np.max(values)
max_arg = np.argmax(values)

print(f"Maximum value of exotic pension = {max_val}, for n = {max_arg + 1}")

plt.plot(ns, values)
plt.scatter([max_arg], [max_val], c='red')
plt.grid(c='lightgrey')
plt.hlines(0, xmin=0, xmax=501, linestyles='--', color='black')
plt.show()





