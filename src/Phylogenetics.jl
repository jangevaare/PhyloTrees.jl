module Phylogenetics

  using Distributions

  export
    Tree,
    AddNode!,
    AddBranch!,
    findroot,
    findleaves,
    postorder,
    preorder

  include("trees.jl")
  include("simulation.jl")
  include("inference.jl")
end
