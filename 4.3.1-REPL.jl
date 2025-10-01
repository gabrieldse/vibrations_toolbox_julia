	M = [9 0; 0 1]
	K = [27 -3; -3 3]
	x0 = [1; 0]
	xd = [0; 0]
	
  using LinearAlgebra
	
  F = eigen(K, M)
	Λ = F.vectors
	S = F.values
	
  # No need to normalize. eigen() does this automatically
  u = Λ[:,1]
	u_hat = Λ[:,1]/sqrt(u'*M*u)
	
  u2 = Λ[:,2]
	u2_hat = Λ[:,2]/sqrt(u2'*M*u2)
	
  Λ2 = S'*K*S
	S = diagm(S)

  Λ2 = S'*K*S
	
  # Solving the two ODE separetely
  
  using DifferentialEquations
	using Plots

  function oscillator!(du, u, p, t)
  	rx, rv = u
	  du[1] = v
	  du[2] = -108*x
	end
	M
	K
