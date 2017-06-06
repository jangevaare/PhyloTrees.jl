"""
    SimpleTree{<: AbstractNode, <: Branch} <: AbstractTree

Phylogenetic tree object
"""
type SimpleTree{N <: AbstractNode} <: AbstractTree{Int, Int}
    nodes::Dict{Int, N}
    branches::Dict{Int, SimpleBranch}
end

const Tree = SimpleTree{Node}
Tree() = Tree(Dict{Int, Node}(), Dict{Int, SimpleBranch}())

const BinaryTree = SimpleTree{BinaryNode{Int}}
BinaryTree() = BinaryTree(Dict{Int, BinaryNode{Int}}(),
                          Dict{Int, SimpleBranch}())

function _getnodes(tree::SimpleTree)
    return tree.nodes
end

function _getbranches(tree::SimpleTree)
    return tree.branches
end

function _addnode!{N}(tree::SimpleTree{N}, label)
    setnode!(tree, label, N())
    return label
end

"""
    NodeTree

Binary phylogenetic tree object with known leaves and per node data
"""
type NodeTree{LI <: AbstractInfo, ND} <: AbstractTree{String, Int}
    nodes::Dict{String, BinaryNode{Int}}
    branches::Dict{Int, Branch{String}}
    leafrecords::Dict{String, LI}
    noderecords::Dict{String, ND}
    rootheight::Nullable{Float64}
end

function NodeTree{LI, ND}(lt::NodeTree{LI, ND}; copyinfo=true, empty=true)
    verify(lt) || error("Tree to copy is not valid")
    leafnames = getleafnames(lt)
    # Leaf records may be conserved across trees, as could be invariant?
    leafrecords = copyinfo ? deepcopy(getleafrecords(lt)) : getleafrecords(lt)
    if empty # Empty out everything else
        nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leafnames))
        branches = Dict{Int, Branch{String}}()
        noderecords = Dict(map(leaf -> leaf => ND(), leafnames))
    else # Make copies of everything
        nodes = deepcopy(nodes)
        noderecords = deepcopy(getnoderecords(lt))
        branches = deepcopy(getbranches(lt))
    end
    return NodeTree{LI, ND}(nodes, branches, leafrecords, noderecords,
                            lt.rootheight)
end

function NodeTree(leaves::AbstractVector{String};
                  rootheight::Nullable{Float64} = Nullable{Float64}(),
                  leaftype::Type = LeafInfo,
                  nodetype::Type = Void)
    leaftype <: AbstractInfo ||
        error("Leaf information structure is not an subtype of AbstractInfo")
    nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leaves))
    leafrecords = Dict(map(leaf -> leaf => leaftype(), leaves))
    noderecords = Dict(map(leaf -> leaf => nodetype(), leaves))
    return NodeTree{leaftype, nodetype}(nodes, Dict{Int, Branch{String}}(),
                                        leafrecords, noderecords, rootheight)
end

function NodeTree(numleaves::Int;
                  rootheight::Nullable{Float64} = Nullable{Float64}(),
                  leaftype::Type = LeafInfo,
                  nodetype::Type = Void)
    leaftype <: AbstractInfo ||
        error("Leaf information structure is not an subtype of AbstractInfo")
    leaves = map(num -> "Leaf $num", 1:numleaves)
    nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leaves))
    leafrecords = Dict(map(leaf -> leaf => leaftype(), leaves))
    noderecords = Dict(map(leaf -> leaf => nodetype(), leaves))
    return NodeTree{leaftype, nodetype}(nodes, Dict{Int, Branch{String}}(),
                                        leafrecords, noderecords, rootheight)
end

function _getnodes(nt::NodeTree)
    return nt.nodes
end

function _getbranches(nt::NodeTree)
    return nt.branches
end

function _getleafnames(nt::NodeTree)
    return keys(nt.leafrecords)
end

function _getleafrecords(nt::NodeTree)
    return nt.leafrecords
end

function _getnoderecords(nt::NodeTree)
    return nt.noderecords
end

function _addnode!{LI, NR}(tree::NodeTree{LI, NR}, label)
    setnode!(tree, label, BinaryNode{Int}())
    setnoderecord!(tree, label, NR())
    return label
end

function _deletenode!(tree::NodeTree, label)
    node = getnode(tree, label)
    if _hasinbound(node)
        deletebranch!(tree, _getinbound(node))
    end
    for b in _getoutbounds(node)
        deletebranch!(tree, n)
    end
    delete!(_getnodes(tree), label)
    delete!(_getnoderecords(tree), label)    
    return label
end

function _verify(tree::NodeTree)
    if Set(findleaves(tree) ∪ findunattacheds(tree)) != Set(getleafnames(tree))
        warn("Leaf records do not match actual leaves of tree")
        return false
    end
    
    if Set(keys(_getnoderecords(tree))) != Set(keys(_getnodes(tree)))
        warn("Leaf records do not match node records of tree")
        return false
    end
    
    rootheight = hasrootheight(tree) ? getrootheight(tree) : NaN
    for leaf in getleafnames(tree)
        if hasheight(tree, leaf)
            if isnan(rootheight)
                rootheight = getheight(tree, leaf) - getrootdistance(tree, leaf)
            end
            if !(getheight(tree, leaf) - rootheight ≈
                 getrootdistance(tree, leaf))
                warn("Leaf height ($(getheight(tree, leaf))) for $leaf does not match branches")
                return false
            end
        end
    end
    return true
end

function _hasrootheight(tree::NodeTree)
    return !isnull(tree.rootheight)
end

function _getrootheight(tree::NodeTree)
    return get(tree.rootheight)
end

function _setrootheight!(tree::NodeTree, height::Float64)
    tree.rootheight = height
    return height
end

function _clearrootheight!(tree::NodeTree)
    tree.rootheight = Nullable{Float64}()
end

"""
    NamedTree

Binary phylogenetic tree object with known leaves
"""
const NamedTree = NodeTree{LeafInfo, Void}

NamedTree(leaves::AbstractVector{String}) = NodeTree(leaves)
NamedTree(numleaves::Int) = NodeTree(numleaves)
