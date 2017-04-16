__precompile__()

module PhyloTrees

# Dependencies
using RecipesBase

# Methods expanded
import Base.show, Base.push!, Base.append!, Base.getindex

# Functions provided
export
    # Trees
    AbstractTree,
    Tree,
    SimpleTree,
    ParameterisedTree,

    # Nodes
    AbstractNode,
    Node,
    BinaryNode,
    countoutbounds,
    getoutbounds,
    hasinbound,
    getinbound,
    getinbounds,
    
    # Branches
    Branch,
    getsource,
    gettarget,
    getlength,
    
    # Utilities
    addnode!,
    addnodes!,
    addbranch!,
    branch!,
    changesource!,
    changetarget!,
    deletenode!,
    deletebranch!,
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

    # Distance
    distance,

    # Traversal
    postorder

# Package files

include("interface.jl")
include("structure.jl")
include("show.jl")
include("construction.jl")
include("utilities.jl")
include("distance.jl")
include("traversal.jl")
include("plot.jl")
end
