"""
Jukes and Cantor 1969 substitution model

Θ = []
or
Θ = [λ]
"""
type JC69 <: SubstitutionModel
  Θ::Vector{Float64}
  π::Vector{Float64}
  relativerate::Bool

  function JC69(Θ::Vector{Float64})
    if !(0 <= length(Θ) <= 1)
      error("Θ is not a valid length for a JC69 model")
    elseif any(Θ .<= 0.)
      error("All elements of Θ must be positive")
    end

    π = [0.25
         0.25
         0.25
         0.25]

    if length(Θ) == 0
      new(Θ, π, true)
    else
      new(Θ, π, false)
    end
  end
end


JC69() = JC69(Float64[])


function show(io::IO, object::JC69)
  print(io, "\r\e[0m\e[1mJ\e[0mukes and \e[1mC\e[0mantor 19\e[1m69\e[0m substitution model")
end


function Q(jc69::JC69)
  if jc69.relativerate
    λ = 1.
  else
    λ = jc69.Θ[1]
  end

  return [[-3*λ λ λ λ]
          [λ -3*λ λ λ]
          [λ λ -3*λ λ]
          [λ λ λ -3*λ]]
end


function P(jc69::JC69, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  if jc69.relativerate
    λ = 1.
  else
    λ = jc69.Θ[1]
  end

  P_0 = 0.25 + 0.75 * exp(-t * λ * 4)
  P_1 = 0.25 - 0.25 * exp(-t * λ * 4)

  return [[P_0 P_1 P_1 P_1]
          [P_1 P_0 P_1 P_1]
          [P_1 P_1 P_0 P_1]
          [P_1 P_1 P_1 P_0]]
end


type JC69Prior <: SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}

  function JC69Prior(Θ)
    if !(0 <= length(Θ) <= 1)
      error("Θ is not a valid length for a JC69 model")
    end
    new(Θ)
  end
end


JC69Prior() = JC69Prior(UnivariateDistribution[])


JC69Prior(Θ::UnivariateDistribution) = JC69Prior([Θ])


function rand(x::JC69Prior)
  return JC69([rand(x.Θ[i]) for i=1:length(x.Θ)])
end


function logprior(prior::JC69Prior, model::JC69)
  lprior = 0.
  lprior += sum([loglikelihood(prior.Θ[i], [model.Θ[i]]) for i=1:length(model.Θ)])
  return lprior
end
