module Phylogenetics

  using Distributions

  export
    Tree,
    AddNode!,
    AddBranch!,
    postorder,
    preorder

  include("trees.jl")
  include("simulation.jl")
  include("inference.jl")
end
