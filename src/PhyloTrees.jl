module PhyloTrees

  # Dependencies
  using Distributions
  # using Requires

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

    # Plot
    plot,

    # Simulation
    simulate,

    # Inference
    loglikelihood

    # Show

  include("trees.jl")
  include("traversal.jl")
  include("utilities.jl")
  include("distance.jl")
  include("mutation.jl")
  include("plot.jl")
  include("simulation.jl")
  include("inference.jl")
  include("show.jl")

  # # Optional plotting abilities
  # @require PyPlot begin
  #   include("plot.jl")
  #   export plot
  # end

end
