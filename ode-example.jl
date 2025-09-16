using Symbolics
using DifferentialEquations
using Plots

# --- 1. Analytical solution (symbolic) ---
@variables t
@variables x(t)
D = Differential(t)

eq = D(x) ~ -3x
ic = x(0) ~ 1

# Solve symbolically
sys = [eq]
ics = [ic]
sol_symbolic = Symbolics.solve_for(Symbolics.solve(sys, [D(x)])[1].rhs, x)  # manual workaround
println("Analytical solution: x(t) = exp(-3t)")

# Define analytical function
x_exact(t) = exp(-3t)

# --- 2. Numerical solution with Runge-Kutta (DifferentialEquations.jl) ---
f(u,p,t) = -3u
u0 = 1.0
tspan = (0.0, 2.0)
prob = ODEProblem(f, u0, tspan)
sol_rk = solve(prob, Tsit5(); saveat=0.1)

# --- 3. Numerical Euler method (manual) ---
function euler(f, u0, tspan, h)
    t0, tf = tspan
    ts = t0:h:tf
    us = zeros(length(ts))
    us[1] = u0
    for i in 1:length(ts)-1
        us[i+1] = us[i] + h * f(us[i], nothing, ts[i])
    end
    return ts, us
end

ts_euler, us_euler = euler(f, u0, tspan, 0.1)

# --- Plot all ---
plot(sol_rk.t, sol_rk.u, label="Runge-Kutta (Tsit5)", lw=2, marker=:circle)
plot!(ts_euler, us_euler, label="Euler (h=0.1)", lw=2, ls=:dash, marker=:star)
plot!(sol_rk.t, x_exact.(sol_rk.t), label="Analytical exp(-3t)", lw=2, ls=:dot)
xlabel!("t")
ylabel!("x(t)")
title!("Solutions of x'(t) = -3x")

