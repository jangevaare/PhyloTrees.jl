type SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}
  π::Nullable{Dirichlet}

  function SubstitutionModelPrior(Θ::Vector{UnivariateDistribution})
    return new(Θ, Nullable{Dirichlet}())
  end

  function SubstitutionModelPrior(Θ::Vector{UnivariateDistribution}, π::Dirichlet)
    if length(π.alpha) != 4
      error("Invalid Dirichlet prior distribution specified")
    end
    return new(Θ, Nullable(π))
  end
end
