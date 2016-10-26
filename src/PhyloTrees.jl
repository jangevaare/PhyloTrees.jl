module PhyloTrees

  # Dependencies
  using Distributions
  using RecipesBase

  # Methods expanded
  import Base.show,
         Base.push!,
         Base.append!,
         Base.copy,
         StatsBase.loglikelihood,
         Base.rand,
         Base.length,
         Base.getindex

  # Functions provided
  export
    # Trees
    Tree,
    Node,
    Branch,
    addnode!,
    addnodes!,
    addbranch!,
    branch!,
    addsubtree!,
    subtree,
    changesource!,
    changetarget!,

    # Traversal algorithms
    postorder,

    # Utilities
    validnode,
    validnodes,
    validbranch,
    validbranches,
    indegree,
    outdegree,
    isroot,
    isleaf,
    isnode,
    findroots,
    findleaves,
    findnodes,
    findnonroots,
    findnonleaves,
    findnonnodes,
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
    SubstitutionModelPrior,
    JC69,
    K80,
    F81,
    F84,
    HKY85,
    TN93,
    GTR,
    JC69Prior,
    K80Prior,
    F81Prior,
    F84Prior,
    HKY85Prior,
    TN93Prior,
    GTRPrior,
    Q,
    P,
    logprior,
    propose,
    rand,

    # Sequences
    Sequence,

    # Simulation
    simulate,

    # Inference
    loglikelihood,
    spr,
    PhyloTrace,
    PhyloIteration,
    transition_kernel_variance

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

  include("sequences.jl")

  include("simulation.jl")

  include("inference/loglikelihoods.jl")
  include("inference/operators.jl")
  include("inference/mcmc.jl")

  include("plot.jl")
end
