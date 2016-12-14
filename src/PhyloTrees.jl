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
    Base.getindex,
    Base.get

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
    findroot,
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
    setlabel!,
    haslabel,
    getlabel,
    setdata!,
    hasdata,
    getdata,

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
