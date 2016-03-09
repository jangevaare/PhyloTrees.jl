module Phylogenetics

  # Dependencies
  using Distributions

  export
    # Tree creation
    Tree,
    add_node!,
    add_branch!,

    # Tree modification
    remove_node!,
    remove_branch!,
    subtree,
    add_subtree!,
    remove_subtree!,

    # Traversal algorithms
    postorder,
    breadth_first,
    preorder,

    # Utilities
    node_index,
    branch_index,
    node_id,
    branch_id
    
    # Mutation

    # Simulation

    # Inference

  include("create_tree.jl")
  include("modify_tree.jl")
  include("traversal.jl")
  include("utilities.jl")
  include("mutation.jl")
  include("simulation.jl")
  include("inference.jl")
end
