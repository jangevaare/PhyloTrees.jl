module PhyloTrees

  # Dependencies
  using
    RecipesBase

  # Methods expanded
  import
    Base.show,
    Base.push!,
    Base.append!,
    Base.length,
    Base.getindex

  # Functions provided
  export
    # Trees
    Tree,

    # Utilities
    addnode!,
    addnodes!,
    addbranch!,
    branch!,
    addsubtree!,
    subtree,
    changesource!,
    changetarget!,
    labelnode!,
    label,
    haslabel,
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

    # Traversal
    postorder

  # Package files
  include("core.jl")
  include("show.jl")
  include("utilities.jl")
  include("distance.jl")
  include("traversal.jl")
  include("plot.jl")
end
