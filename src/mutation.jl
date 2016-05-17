abstract SubstitutionModel


type SubstitutionModelPrior
  Θ::Vector{UnivariateDistribution}
  π::Nullable{Dirichlet}
end


include("mutation/jc69.jl")
include("mutation/k80.jl")
include("mutation/f81.jl")
include("mutation/f84.jl")
include("mutation/hky85.jl")
include("mutation/tn93.jl")
include("mutation/gtr.jl")
