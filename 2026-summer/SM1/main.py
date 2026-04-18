from models import *
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

params = [.8, .01, .01, .4, 100, 20]
z0 = [80, 10]  # Initial population: 10 prey, 5 predators
t_span = (0, 30)  # Time start and end
t_eval = np.linspace(0, 30, 500) # Points where we want the solution

sol = solve_ivp(
    lotka_volterra,
    t_span,
    z0,
    args=params,
    t_eval=t_eval,
    method='Radau' # Explicit Runge-Kutta method
)

# 4. Visualization
plt.figure(figsize=(10, 5))
plt.plot(sol.t, sol.y[0], label='Prey (x)')
plt.plot(sol.t, sol.y[1], label='Predator (y)')
plt.xlabel('Time')
plt.ylabel('Population')
plt.title('Lotka-Volterra Predator-Prey Dynamics')
plt.legend()
plt.grid(True)
plt.show()

z1 = [10, 5]

sol1 = solve_ivp(
    lotka_volterra,
    t_span,
    z1,
    args=params,
    t_eval=t_eval,
    method='LSODA' # Explicit Runge-Kutta method
)

z2 = [19, 10]

sol2 = solve_ivp(
    lotka_volterra,
    t_span,
    z2,
    args=params,
    t_eval=t_eval,
    method='LSODA' # Explicit Runge-Kutta method
)

z3 = [25, 15]

sol3 = solve_ivp(
    lotka_volterra,
    t_span,
    z3,
    args=params,
    t_eval=t_eval,
    method='LSODA' # Explicit Runge-Kutta method
)

z4 = [30, 20]

sol4 = solve_ivp(
    lotka_volterra,
    t_span,
    z4,
    args=params,
    t_eval=t_eval,
    method='LSODA' # Explicit Runge-Kutta method
)

plt.figure(figsize=(10, 5))
plt.plot(sol.y[0], sol.y[1])
plt.plot(sol1.y[0], sol1.y[1])
plt.plot(sol2.y[0], sol2.y[1])
plt.plot(sol3.y[0], sol3.y[1])
plt.plot(sol4.y[0], sol4.y[1])
plt.xlabel('Time')
plt.ylabel('Population')
plt.title('Lotka-Volterra Predator-Prey Dynamics')
plt.grid(True)
plt.show()
plt.plot()



#fig = plt.figure(figsize=(10, 8))
#ax = fig.add_subplot(projection='3d')

# Using *sol.y unpacks the three rows (x, y, p) directly into the plot function
#ax.plot(*sol.y, lw=0.7)

#ax.set_xlabel("Prey X")
#ax.set_ylabel("Prey Y")
#ax.set_zlabel("Predator Z")
#ax.set_title("3D Phase Portrait: Predator-Prey Dynamics")

# Optional: Make the background pane transparent for a cleaner look
#ax.xaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
#ax.yaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
#ax.zaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
#
#plt.show()