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
    is_root,
    is_leaf,
    is_node,
    find_root,
    find_leaves,
    find_nodes,
    check_tree,

    # Mutation
    JC69,
    K80,
    F81,
    F84,
    HKY85,
    TN93,
    GTR,
    UNREST,
    Q,
    P,

    # Simulation
    simulate!,

    # Inference
    loglikelihood

  include("create_tree.jl")
  include("modify_tree.jl")
  include("traversal.jl")
  include("utilities.jl")
  include("mutation.jl")
  include("simulation.jl")
  include("inference.jl")
end
