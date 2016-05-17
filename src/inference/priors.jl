type SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}
  π::Nullable{Dirichlet}
end
