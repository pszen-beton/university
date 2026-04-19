import numpy as np

A = np.array([[4, 2, 0], [4, 102, 0], [104, 0, 100]])

b = np.array([5, 105, 0])

def bond_pv(years: int, maturity: float, rate:float, coupon: float = 0) -> float:

    years_array = np.array([i for i in range(1, years + 1)])

    discounting_factors = np.exp(-rate * years_array)

    payments_factors = np.ones(years) * coupon
    payments_factors[-1] = payments_factors[-1] + 1

    payments = payments_factors * maturity

    PV = sum(discounting_factors * payments)

    return(PV)

print(bond_pv(4, 1, 0.02, 0.05))
print(bond_pv(5, 1, 0.02))
print(bond_pv(5, 1, 0.02, 0.04))
print(bond_pv(4, 1, 0.02, 0.02))

#----------

def bond_dur(years: int, maturity: float, rate: float, coupon: float = 0) -> float:
    years_array = np.array([i for i in range(1, years + 1)])

    discounting_factors = np.exp(-rate * years_array)

    payments_factors = np.ones(years) * coupon
    payments_factors[-1] = payments_factors[-1] + 1

    payments = payments_factors * maturity

    dur_numerator = sum(discounting_factors * payments * years_array)
    dur_denominator = sum(discounting_factors * payments)

    return(dur_numerator / dur_denominator)

print(bond_dur(4, 1, 0.02, 0.05))
print(bond_dur(5, 1, 0.02))
print(bond_dur(5, 1, 0.02, 0.04))
print(bond_dur(4, 1, 0.02, 0.02))

##Zad2
print("=== ZAD 2 ===")
#V of rent
years_array = np.array([i for i in range(1, 8)])
discounting_factors = np.exp(-0.02 * years_array)

payments = [100 for _ in range(7)]
PV = sum(discounting_factors * payments)

print(PV)

PVA = bond_pv(3, 100, 0.02)
print(PVA)

PVB = bond_pv(8, 100, 0.02, 0.05)
print(PVB)

###dur num
rate = .02

years = np.array([i for i in range(1, 8)])
discounting_factors = np.exp(-rate * years)

num_b_term = 8 * 105 * np.exp(-rate * 8) + sum(years * 5 * discounting_factors)
print('numerator b term:', num_b_term)

num_a_term = 3 * 100 * np.exp(-rate * 3)
print('numerator a term:', num_a_term)

#dur denom

years = np.array([i for i in range(1, 8)])
discounting_factors = np.exp(-rate * years)

den_b_term = 105 * np.exp(-rate * 8) + sum(5 * discounting_factors)
print('numerator b term:', den_b_term)

den_a_term = 100 * np.exp(-rate * 3)
print('numerator a term:', den_a_term)

print((1050 + 50 * np.exp(-0.04)) / 50)