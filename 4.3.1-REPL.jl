  using LinearAlgebra
  # 1/8 - Escrever o sistema de equações
  M = [9 0; 0 1]
	K = [27 -3; -3 3]
	X0 = [1; 0]
  Xd = [0; 0]

  # 2 - Assumir a solução e dar condições iniciais
  
  # 3 - Resolver o problema de auto valores e autovetores	
  
  F = eigen(K, M)
  # 4 - Encontrar frequencias naturais (ω) e modos (U_hat)
  ω² = F.values
  U = F.vectors
  Ω = diagm(ω²)

  # 5 - Normalizar os modos
  
  # Os vetores já saem normalizados
  U_hat = U
	
  # Mas seria assim
  #u = F.vectors[:,1]
	#u_hat = u/sqrt(u'*M*u)
	
  #u2 = F.vectors[:,2]
	#u2_hat = u2[:,2]/sqrt(u2'*M*u2)
  

  # 6 - Construir matrix de modos a partir de u_hat1 e u_hat2
  
  # Aqui como u já é normalizado e é uma matriz que contem os dois vetores
  
  S = U_hat 
  
  # 7 - Realizar a Mudaça de Variáveis, para o espaço modal
  
  
  #r = inv(S)*X
  # Mas quem é X ? É a matrix U ?
  # O texto fala de comparar a resolução 4.3.1 (analise modal) 4.1.6. Tem algum outro jeito de resolver que não seja analise modal ?
  
  r0 = inv(S)*X0 
  rd = inv(S)*Xd
  
  I = S'*M*S
  Λ = S'*K*S
  
  #O problema decoplado fica:

  # r1dd + ω1^2*r1 = 0
  # r2dd + ω2^2*r2 = O

   # Solving the two ODE separetely
  
  using DifferentialEquations
  using Plots

  # State vector u = [x, v], where v = dx/dt
  function oscillator!(du, u, p, t)
      x, v = u
      du[1] = v
      du[2] = -ω²[1]*x
  end
  
  tspan = (0.0, 12.0)   # simulate for 20 seconds

  # Define ODE problem
  #
  u0 = [r0[1], 0.0]
  prob = ODEProblem(oscillator!, u0, tspan)

  # Solve with Dormand–Prince 5
  sol = solve(prob, DP5(); saveat=0.1)

  ########## 9 - Antes de plotar, voltar as variáveis
  # r₁(t)
  r1 = [u[1] for u in sol.u]

  # Voltar pro espaço físico: X(t) = S[:,1]*r1(t)
  X = [S[:,1] .* r1[i] for i in eachindex(r1)]

  # Extrair cada coordenada física
  x1 = [X[i][1] for i in 1:length(X)]
  x2 = [X[i][2] for i in 1:length(X)]

  plot(sol.t, x1, label="x₁(t)", lw=2)
  plot!(sol.t, x2, label="x₂(t)", lw=2)
  xlabel!("Tempo (s)")
  ylabel!("Deslocamento físico")
  title!("Resposta no espaço físico - Modo 1")
  gui()  
  readline()
