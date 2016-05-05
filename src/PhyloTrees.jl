module PhyloTrees

  # Dependencies
  using Distributions
  using DataFrames
  using Gadfly

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
    parentnode,
    childnodes,
    descendantcount,
    descendantnodes,
    ancestorcount,
    ancestornodes,
    nodetype,

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
    plot

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
