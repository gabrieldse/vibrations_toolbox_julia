using DifferentialEquations
using Plots

# Parameters
m = 100.0       # mass
c = 195       # damping
k = 500.0       # stiffness

# State vector u = [x, v], where v = dx/dt
function oscillator!(du, u, p, t)
    x, v = u
    du[1] = v
    du[2] = -(c/m)*v - (k/m)*x + 150 * cos(5*t) / m
end

# Initial conditions
u0 = [0.01, 0.5]       # x(0)=1, v(0)=0
tspan = (0.0, 20.0)   # simulate for 20 seconds

# Define ODE problem
prob = ODEProblem(oscillator!, u0, tspan)

# Solve with Dormand–Prince 5
sol = solve(prob, DP5(); saveat=0.1)

# Plot results
plot(sol.t, [u[1] for u in sol.u], label="Displacement x(t)", lw=2)
#plot!(sol.t, [u[2] for u in sol.u], label="Velocity v(t)", lw=2, ls=:dash)
xlabel!("Time (s)")
ylabel!("Response")
title!("1DOF Vibration System (DP5)")

gui()
readline()
