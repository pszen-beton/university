import numpy as np

def rent(n, m, i, type='immediate'):


    if type=='immediate':
        flow = np.array([(1 / m) * (1 / (1 + (i / m))) ** k for k in range(1, n * m + 1)])

    elif type=='annuity-due':
        flow = np.array([(1 / m) * (1 / (1 + (i / m))) ** k for k in range(n * m)])

    else:
        raise ValueError('Unknown type')

    return flow

def rent_formula(n, m, i, type='immediate'):
    v = (1 / (1 + (i / m)))
    if type=='immediate':
        return (1 - v ** (m * n)) / i
    elif type=='annuity-due':
        d = i / (1 + (i / m))
        return (1 - v ** (m * n)) / d
    else:
        raise ValueError('Unknown type')


n = 10
m = 4
i = 0.03

print(f"Result for immediate flow: {sum(rent(n, m, i, type='immediate'))}")
print(f"Directly calculated immediate: {rent_formula(n, m, i, type='immediate')}")

print(f"Result for annuity-due flow: {sum(rent(n, m, i, type='annuity-due'))}")
print(f"Directly calculated annuity-due: {rent_formula(n, m, i, type='annuity-due')}")

##zad3

print(rent(20, 1, 0.07, type='immediate') * 1000)
