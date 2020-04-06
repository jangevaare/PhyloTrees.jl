module PhyloTrees

  using RecipesBase

  # Methods expanded
  import
    Base.show,
    Base.push!,
    Base.append!,
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
    setsource!,
    settarget!,
    setlength!,
    setheight!,
    changesource!,
    changetarget!,
    changelength!,
    changeheight!,
    deletenode!,
    deletebranch!,
    indegree,
    outdegree,
    isroot,
    isleaf,
    isinternal,
    findroots,
    findroot,
    findleaves,
    findinternals,
    findexternals,
    findnonroots,
    findnonleaves,
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
  include("structure.jl")
  include("show.jl")
  include("construction.jl")
  include("utilities.jl")
  include("distance.jl")
  include("traversal.jl")
  include("plotrecipe.jl")
end
