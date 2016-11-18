"""
Tamura and Nei 1993 substitution model

Θ = [κ1, κ2]
or
Θ = [α1, α2, β]
"""
type TN93 <: SubstitutionModel
  Θ::Vector{Float64}
  π::Vector{Float64}
  relativerate::Bool

  function TN93(Θ::Vector{Float64}, π::Vector{Float64})
    if any(Θ .<= 0.)
      error("All elements of Θ must be positive")
    elseif !(2 <= length(Θ) <= 3)
      error("Θ is not a valid length for a TN93 model")
    elseif length(π) !== 4
      error("π must be of length 4")
    elseif !all(0. .< π .< 1.)
      error("All base proportions must be between 0 and 1")
    elseif sum(π) !== 1.
      error("Base proportions must sum to 1")
    end

    if length(Θ) == 2
      new(Θ, π, true)
    else
      new(Θ, π, false)
    end
  end
end


function show(io::IO, object::TN93)
  print(io, "\r\e[0m\e[1mT\e[0mamura, and \e[1mN\e[0mei 19\e[1m93\e[0m substitution model")
end


function Q(tn93::TN93)
  α_1 = tn93.Θ[1]
  α_2 = tn93.Θ[2]
  if tn93.relativerate
    β = 1.0
  else
    β = tn93.Θ[3]
  end

  π_T = tn93.π[1]
  π_C = tn93.π[2]
  π_A = tn93.π[3]
  π_G = tn93.π[4]

  π_R = π_A + π_G
  π_Y = π_T + π_C

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


function P(tn93::TN93, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  α_1 = tn93.Θ[1]
  α_2 = tn93.Θ[2]
  if tn93.relativerate
    β = 1.0
  else
    β = tn93.Θ[3]
  end

  π_T = tn93.π[1]
  π_C = tn93.π[2]
  π_A = tn93.π[3]
  π_G = tn93.π[4]

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


type TN93Prior <: SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}
  π::Dirichlet

  function TN93Prior(Θ, π)
    if !(2 <= length(Θ) <= 3)
      error("Θ is not a valid length for a TN93 model")
    elseif length(π.alpha) !== 4
      error("Invalid Dirichlet distribution")
    end
    new(Θ, π)
  end
end


function rand(x::TN93Prior)
  return TN93([rand(x.Θ[i]) for i=1:length(x.Θ)], rand(x.π))
end


function logprior(prior::TN93Prior, model::TN93)
  lprior = 0.
  lprior += sum([loglikelihood(prior.Θ[i], [model.Θ[i]]) for i=1:length(model.Θ)])
  lprior += loglikelihood(prior.π, [model.π])
  return lprior
end
