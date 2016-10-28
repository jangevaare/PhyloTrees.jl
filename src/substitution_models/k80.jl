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
  α = k80.Θ[1]
  if k80.relativerate
    β = 1.0
  else
    β = k80.Θ[2]
  end
  return [[-(α + 2 * β) α β β]
          [α -(α + 2 * β) β β]
          [β β -(α + 2 * β) α]
          [β β α -(α + 2 * β)]]
end


function P(k80::K80, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  α = k80.Θ[1]
  if k80.relativerate
    β = 1.0
  else
    β = k80.Θ[2]
  end

  P_0 = 0.25 + 0.25 * exp(-4 * β * t) + 0.5 * exp(-2 * (α + β) * t)
  P_1 = 0.25 + 0.25 * exp(-4 * β * t) - 0.5 * exp(-2 * (α + β) * t)
  P_2 = 0.25 - 0.25 * exp(-4 * β * t)

  return [[P_0 P_1 P_2 P_2]
          [P_1 P_0 P_2 P_2]
          [P_2 P_2 P_0 P_1]
          [P_2 P_2 P_1 P_0]]
end


"""
Generate a `SubstitutionModel` proposal using the multivariate normal
distribution as the transition kernel, with a previous set of
`SubstitutionModel` parameters as the mean vector and a transition kernel
variance as the variance-covariance matrix
"""
function propose(currentstate::K80,
                 transition_kernel_variance::Array{Float64, 2})
  return K80(rand(MvNormal(currentstate.Θ, transition_kernel_variance)))
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
