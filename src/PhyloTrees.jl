__precompile__()

module PhyloTrees

# Dependencies
using RecipesBase

# Methods expanded
import Base.show, Base.showall, Base.push!, Base.append!, Base.getindex

# Functions provided
export
    # Trees
    AbstractTree,
    SimpleTree,
    Tree, BinaryTree,
    NodeTree, NamedTree,
    getnodes,
    findroots,
    findleaves,
    findinternals,
    findnonroots,
    findnonleaves,
    findnoninternals,
    getbranches,
    getnoderecords,
    getleafrecords,
    verify,
    hasrootheight,
    getrootheight,
    setrootheight!,
    clearrootheight!,

    # Information about nodes
    AbstractNode,
    Node,
    BinaryNode,
    hasnode,
    getnode,
    addnode!,
    addnodes!,
    deletenode!,
    getnoderecord,
    setnoderecord!,
    indegree,
    getinbound,
    setinbound!,
    deleteinbound!,
    hasinbound,
    outdegree,
    hasoutboundspace,
    getoutbounds,
    addoutbound!,
    deleteoutbound!,
    isroot,
    isleaf,
    isinternal,
    isunattached,
    areconnected,
    nodepath,
    branchpath,
    getrootdistance,
    parentnode,
    childnodes,
    descendantcount,
    descendantnodes,
    ancestorcount,
    ancestornodes,

    
    # Information about branches
    Branch,
    hasbranch,
    getbranch,
    addbranch!,
    branch!,
    deletebranch!,
    getsource,
    gettarget,
    getlength,
    changesource!,
    changetarget!,

    # Information about leaves
    getleafnames,
    getleafrecord,
    setleafrecord!,
    hasheight,
    getheight,
    setheight!,

    # Utilities
    plot,
    
    # Distance
    distance,

    # Traversal
    postorder

# module Interface
# export
#     _getnodes,
#     _getbranches,
#     _addnode!,
#     _addbranch!,
#     _hasnode,
#     _hasbranch,
#     _addnodes!,
#     _deletenode!,
#     _deletebranch!,
#     _branch!,
#     _verify,
#     _hasrootheight,
#     _getrootheight,
#     _setrootheight!,
#     _clearrootheight!,
#     _newnodelabel,
#     _newbranchlabel,
#     _getleafnames,
#     _getleafrecords,
#     _getleafrecord,
#     _setleafrecord!,
#     _hasheight,
#     _getheight,
#     _setheight!,
#     _getnoderecords,
#     _getnoderecord,
#     _setnoderecord!,
#     _hasinbound,
#     _outdegree,
#     _hasoutboundspace,
#     _getinbound,
#     _setinbound!,
#     _deleteinbound!,
#     _getoutbounds,
#     _addoutbound!,
#     _deleteoutbound!,
#     _indegree,
#     _isroot,
#     _isleaf,
#     _isinternal,
#     _isunattached,
#     _getsource,
#     _gettarget,
#     _getlength,
#     _setsource!,
#     _settarget!
# end

# Package files
include("interface.jl")
include("structure.jl")
include("trees.jl")
include("show.jl")
include("utilities.jl")
include("distance.jl")
include("traversal.jl")
include("plot.jl")


end
