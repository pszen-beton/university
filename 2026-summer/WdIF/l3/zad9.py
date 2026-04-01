i = 0.06
v = 1 / (1 + i)
n = 15

EX = (1/3) * (500 + 1000 + 1500)

EPV = EX * (1 - v ** n) / i

print(EPV)