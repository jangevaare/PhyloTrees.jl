""""
Felsenstein 1984 substitution model

Θ = [κ, β]
"""
type F84 <: SubstitutionModel
  Θ::Vector{Float64}
  π::Vector{Float64}
  relativerate::Bool

  function F84(Θ::Vector{Float64}, π::Vector{Float64})
    if any(Θ .<= 0.)
      error("All elements of Θ must be positive")
    elseif !(1 <= length(Θ) <= 2)
      error("Θ is not a valid length for an F84 model")
    elseif length(π) !== 4
      error("π must be of length 4")
    elseif !all(0. .< π .< 1.)
      error("All base proportions must be between 0 and 1")
    elseif sum(π) !== 1.
      error("Base proportions must sum to 1")
    end
    if length(Θ) == 1
      new(Θ, π, true)
    else
      new(Θ, π, false)
    end
  end
end


function show(io::IO, object::F84)
  print(io, "\r\e[0m\e[1mF\e[0melsenstein 19\e[1m84\e[0m substitution model")
end


function Q(f84::F84)
  κ = f84.Θ[1]
  if f84.relativerate
    β = 1.
  else
    β = f84.Θ[2]
  end

  π_T = f84.π[1]
  π_C = f84.π[2]
  π_A = f84.π[3]
  π_G = f84.π[4]

  π_R = π_A + π_G
  π_Y = π_T + π_C

  α_1 = (1 + κ/π_Y) * β
  α_2 = (1 + κ/π_R) * β

  Q_TT = -((α_1 * π_C) + (β * π_R))
  Q_TC = α_1 * π_C
  Q_TA = β * π_A
  Q_TG = β * π_G

  Q_CT = α_1 * π_T
  Q_CC = -((α_1 * π_T) + (β * π_R))
  Q_CA = Q_TA
  Q_CG = Q_TG

  Q_AT = β * π_T
  Q_AC = β * π_C
  Q_AA = -((α_2 * π_G) + (β * π_Y))
  Q_AG = α_2 * π_G

  Q_GT = Q_AT
  Q_GC = Q_AC
  Q_GA = α_2 * π_A
  Q_GG = -((α_2 * π_A) + (β * π_Y))

  return [[Q_TT Q_TC Q_TA Q_TG]
          [Q_CT Q_CC Q_CA Q_CG]
          [Q_AT Q_AC Q_AA Q_AG]
          [Q_GT Q_GC Q_GA Q_GG]]
end


function P(f84::F84, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  κ = f84.Θ[1]
  if f84.relativerate
    β = 1.
  else
    β = f84.Θ[2]
  end

  π_T = f84.π[1]
  π_C = f84.π[2]
  π_A = f84.π[3]
  π_G = f84.π[4]

  π_R = π_A + π_G
  π_Y = π_T + π_C

  α_1 = (1 + κ/π_Y) * β
  α_2 = (1 + κ/π_R) * β

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


type F84Prior <: SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}
  π::Dirichlet

  function F84Prior(Θ, π)
    if !(1 <= length(Θ) <= 2)
      error("Θ is not a valid length for an F84 model")
    elseif length(π.alpha) !== 4
      error("Invalid Dirichlet distribution")
    end
    new(Θ, π)
  end
end


function rand(x::F84Prior)
  return F84([rand(x.Θ[i]) for i=1:length(x.Θ)], rand(x.π))
end


function logprior(prior::F84Prior, model::F84)
  lprior = 0.
  lprior += sum([loglikelihood(prior.Θ[i], [model.Θ[i]]) for i=1:length(model.Θ)])
  lprior += loglikelihood(prior.π, [model.π])
  return lprior
end
