import numpy as np
from collections.abc import Callable

def lotka_volterra(t : float, init: list[float], a: float, b: float, c: float, d: float, K: float = 0, A: float = 0, Phi: Callable = None) -> list[float]:
    x, y = init

    if K == 0:
        env = 1
    else:
        env = (1 - x / K)

    if A == 0:
        alle = 1
    else:
        alle = (x / A - 1)

    if Phi is None:
        dxdt = a * x * env * alle - b * x * y
        dydt = c * x * y - d * y
    else:
        dxdt = a * x * y * env * alle - Phi(x, y) * y
        dydt = Phi(x, y) * y - d * y

    return [dxdt, dydt]

#sample Phi functions:

def holling(x: float, y: float, N: float, A: float, p: float = 1) -> float:
    if A < 0 or N < 0:
        raise ValueError("A and N must be strictly positive")

    return (N * (x ** p)) / (A ** p + x ** p)

def ivlev(x: float, y: float, N: float, A: float) -> float:
    return N - np.exp(-A * x)

