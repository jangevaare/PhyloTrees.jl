"""
Prior distributions for the parameters of a nucleotide substitution model
"""
type SubstitutionModelPriors
  Θ::Vector{UnivariateDistribution}
  π::Nullable{Dirichlet}

  function SubstitutionModelPriors(Θ::Vector{UnivariateDistribution})
    return new(Θ, Nullable{Dirichlet}())
  end

  function SubstitutionModelPriors(Θ::Vector{UnivariateDistribution}, π::Dirichlet)
    if length(π.alpha) != 4
      throw("Invalid Dirichlet prior distribution specified")
    end
    return new(Θ, Nullable(π))
  end
end


function rand(priors::SubstitutionModelPriors)
  Θ = Float64[]
  for i = 1:length(priors.Θ)
    push!(Θ, rand(priors.Θ[i]))
  end
  if !isnull(priors.π)
    π = rand(get(priors.π))
    return Θ, π
  else
    return Θ
  end
end


function logprior(model::SubstitutionModel,
                  priors::SubstitutionModelPriors)
  lp = 0.
  for i = 1:length(priors.Θ)
    lp += loglikelihood(priors.Θ[i], [model.Θ[i]])
  end
  if !isnull(priors.π)
    lp += loglikelihood(priors.π, [model.π])
  end
  return lp
end
