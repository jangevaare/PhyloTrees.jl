module PhyloTrees

  # Dependencies
  using Distributions

  # Methods expanded
  import Base.show
  import Base.push!
  import Base.append!
  import StatsBase.loglikelihood
  import Plots.plot

  # Functions provided
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

    # Substitution Models
    SubstitutionModel,
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
    simulate

    # Inference

    # Plot

  # Package files
  include("structure/nodes.jl")
  include("structure/branches.jl")
  include("structure/trees.jl")

  include("utilities/traversal.jl")
  include("utilities/construction.jl")
  include("utilities/topology.jl")
  include("utilities/distance.jl")

  include("substitution_models/abstract.jl")
  include("substitution_models/jc69.jl")
  include("substitution_models/k80.jl")
  include("substitution_models/f81.jl")
  include("substitution_models/f84.jl")
  include("substitution_models/hky85.jl")
  include("substitution_models/tn93.jl")
  include("substitution_models/gtr.jl")

  include("simulation.jl")

  include("inference/priors.jl")
  include("inference/loglikelihoods.jl")
  include("inference/operators.jl")
  include("inference/mcmc.jl")

  include("plot.jl")
end
