module PhyloTrees

  # Dependencies
  using Distributions

  export
    # Trees
    Tree,
    Node,
    Branch,
    addnode!,
    addbranch!,
    branch!,
    addsubtree!,
    subtree,

    # Traversal algorithms
    postorder,

    # Utilities
    isroot,
    isleaf,
    isnode,
    findroots,
    findleaves,
    findnodes,
    nodepath,
    branchpath,

    # Distance
    distance,

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
    simulate,

    # Inference
    loglikelihood

  include("trees.jl")
  include("traversal.jl")
  include("utilities.jl")
  include("distance.jl")
  include("mutation.jl")
  include("simulation.jl")
  include("inference.jl")
end
