module Phylogenetics

  using Distributions

  export
    Tree,
    add_node!,
    remove_node!,
    add_branch!,
    remove_branch!,
    findroot,
    findleaves,
    postorder,
    preorder

  include("trees.jl")
  include("simulation.jl")
  include("inference.jl")
end
