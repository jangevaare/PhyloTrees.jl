"""
Felsenstein 1981 substitution model

Θ = []
or
Θ = [β]
"""
type F81 <: SubstitutionModel
  Θ::Vector{Float64}
  π::Vector{Float64}

  function F81(Θ::Vector{Float64}, π::Vector{Float64})
    if !(0 <= length(Θ) <= 1)
      error("Θ is not a valid length for F81 model")
    elseif any(Θ .<= 0.)
      error("All elements of Θ must be positive")
    elseif length(π) !== 4
      error("π must be of length 4")
    elseif !all(0. .< π .< 1.)
      error("All base proportions must be between 0 and 1")
    elseif sum(π) !== 1.
      error("Base proportions must sum to 1")
    end
    new(Θ, π)
  end
end


F81(π::Vector{Float64}) = F81(Float64[], π)


function show(io::IO, object::F81)
  print(io, "\r\e[0m\e[1mF\e[0melsenstein 19\e[1m81\e[0m substitution model")
end


function Q(f81::F81)
  if length(f81.Θ) == 1
    β = f81.Θ[1]
  else
    β = 1.
  end
  π_T = f81.π[1]
  π_C = f81.π[2]
  π_A = f81.π[3]
  π_G = f81.π[4]

  return β * [[-(π_C + π_A + π_G) π_C π_A π_G]
              [π_T -(π_T + π_A + π_G) π_A π_G]
              [π_T π_C -(π_T + π_C + π_G) π_G]
              [π_T π_C π_A -(π_T + π_C + π_A)]]
end


function P(f81::F81, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  if length(f81.Θ) == 1
    α_1 = f81.Θ[1]
    α_2 = f81.Θ[1]
    β = f81.Θ[1]
  else
    α_1 = 1.
    α_2 = 1.
    β = 1.
  end
  π_T = f81.π[1]
  π_C = f81.π[2]
  π_A = f81.π[3]
  π_G = f81.π[4]

  π_R = π_A + π_G
  π_Y = π_T + π_C

  e_2 = exp(-β * t)
  e_3 = exp(-((π_R * α_2) + (π_Y * β)) * t)
  e_4 = exp(-((π_Y * α_1) + (π_R * β)) * t)

  P_TT = π_T + ((π_T * π_R)/π_Y) * e_2 + (π_C/π_Y) * e_4
  P_TC = π_C + ((π_T * π_R)/π_Y) * e_2 - (π_C/π_Y) * e_4
  P_TA = π_A * (1 - e_2)
  P_TG = π_G * (1 - e_2)

  P_CT = π_T + ((π_T * π_R)/π_Y) * e_2 - (π_T/π_Y) * e_4
  P_CC = π_C + ((π_T * π_R)/π_Y) * e_2 + (π_T/π_Y) * e_4
  P_CA = π_A * (1 - e_2)
  P_CG = π_G * (1 - e_2)

  P_AT = π_T * (1 - e_2)
  P_AC = π_C * (1 - e_2)
  P_AA = π_A + ((π_A * π_Y)/π_R) * e_2 + (π_G/π_R) * e_3
  P_AG = π_G + ((π_G * π_Y)/π_R) * e_2 - (π_G/π_R) * e_3

  P_GT = π_T * (1 - e_2)
  P_GC = π_C * (1 - e_2)
  P_GA = π_A + ((π_A * π_Y)/π_R) * e_2 - (π_A/π_R) * e_3
  P_GG = π_G + ((π_G * π_Y)/π_R) * e_2 + (π_A/π_R) * e_3

  return [[P_TT P_TC P_TA P_TG]
          [P_CT P_CC P_CA P_CG]
          [P_AT P_AC P_AA P_AG]
          [P_GT P_GC P_GA P_GG]]
end


"""
Generate a `SubstitutionModel` proposal using the multivariate normal
distribution as the transition kernel, with a previous set of
`SubstitutionModel` parameters as the mean vector and a transition kernel
variance as the variance-covariance matrix
"""
function propose(currentstate::F81,
                 transition_kernel_variance::Array{Float64, 2})
  if length(currentstate.Θ) == 1
    return F81(rand(MvNormal(currentstate.Θ, transition_kernel_variance)),
               rand(Dirichlet([5
                               5
                               5
                               5])))
  else
    return F81(rand(Dirichlet([5
                               5
                               5
                               5])))
  end
end
