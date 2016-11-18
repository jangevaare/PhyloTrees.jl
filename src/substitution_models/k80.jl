"""
Kimura 1980 substitution model

Θ = [κ]
or
Θ = [α, β]
"""
type K80 <: SubstitutionModel
  Θ::Vector{Float64}
  π::Vector{Float64}
  relativerate::Bool

  function K80(Θ::Vector{Float64})
    if any(Θ .<= 0.)
      error("All elements of Θ must be positive")
    elseif !(1 <= length(Θ) <= 2)
      error("Θ is not a valid length for a K80 model")
    end
    π = [0.25
         0.25
         0.25
         0.25]
    if length(Θ) == 1
      new(Θ, π, true)
    else
      new(Θ, π, false)
    end
  end
end


function show(io::IO, object::K80)
  print(io, "\r\e[0m\e[1mK\e[0mimura 19\e[1m80\e[0m substitution model")
end


function Q(k80::K80)
  if k80.relativerate
    κ = k80.Θ[1]
    return [[-(κ + 2) κ 1 1]
            [κ -(κ + 2) 1 1]
            [1 κ -(κ + 2) 1]
            [1 1 κ -(κ + 2)]]
  else
    α = k80.Θ[1]
    β = k80.Θ[2]
    return [[-(α + 2 * β) α β β]
            [α -(α + 2 * β) β β]
            [β β -(α + 2 * β) α]
            [β β α -(α + 2 * β)]]
  end
end


function P(k80::K80, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  if k80.relativerate
    κ = k80.Θ[1]
    P_0 = 0.25 + (0.25 * exp(-4 * t/(κ + 2))) + (0.5 * exp(-2 * t * (κ + 1)/(κ +2)))
    P_1 = 0.25 + (0.25 * exp(-4 * t/(κ + 2))) - (0.5 * exp(-2 * t * (κ + 1)/(κ +2)))
    P_2 = 0.25 - (0.25 * exp(-4 * t/(κ + 2)))
  else
    α = k80.Θ[1]
    β = k80.Θ[2]
    P_0 = 0.25 + (0.25 * exp(-4 * β * t)) + (0.5 * exp(-2 * (α + β) * t))
    P_1 = 0.25 + (0.25 * exp(-4 * β * t)) - (0.5 * exp(-2 * (α + β) * t))
    P_2 = 0.25 - (0.25 * exp(-4 * β * t))
  end

  return [[P_0 P_1 P_2 P_2]
          [P_1 P_0 P_2 P_2]
          [P_2 P_2 P_0 P_1]
          [P_2 P_2 P_1 P_0]]
end


type K80Prior <: SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}


  function K80Prior(Θ)
    if !(1 <= length(Θ) <= 2)
      error("Θ is not a valid length for a K80 model")
    end
    new(Θ)
  end
end


function rand(x::K80Prior)
  return K80([rand(x.Θ[i]) for i=1:length(x.Θ)])
end


function logprior(prior::K80Prior, model::K80)
  lprior = 0.
  lprior += sum([loglikelihood(prior.Θ[i], [model.Θ[i]]) for i=1:length(model.Θ)])
  return lprior
end
