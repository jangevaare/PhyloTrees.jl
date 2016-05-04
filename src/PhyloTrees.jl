module PhyloTrees

  # Dependencies
  using Distributions
  using DataFrames

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
    validnode,
    isroot,
    isleaf,
    isnode,
    findroots,
    findleaves,
    findnodes,
    areconnected,
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
    loglikelihood,

    # Show

    # Plot
    plotdata

  include("trees.jl")
  include("traversal.jl")
  include("utilities.jl")
  include("distance.jl")
  include("mutation.jl")
  include("simulation.jl")
  include("inference.jl")
  include("show.jl")
  include("plot.jl")

end
