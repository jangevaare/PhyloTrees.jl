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
type NodeTree{NodeData} <: AbstractTree{String, Int}
    nodes::Dict{String, BinaryNode{Int}}
    branches::Dict{Int, Branch{String}}
    leafrecords::Dict{String, TypedInfo{String}}
    noderecords::Dict{String, NodeData}
end

function NodeTree{ND}(lt::NodeTree{ND}; deep=true, empty=true)
    verify(lt) || error("Tree to copy is not valid")
    leafrecords = deep ? deepcopy(getleafrecords(lt)) : getleafrecords(lt)
    if empty
        nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), keys(leafrecords)))
        noderecords = Dict(map(leaf -> leaf => ND(), keys(leafrecords)))
    elseif deep
        nodes = deepcopy(nodes)
        noderecords = deepcopy(getnoderecords(lt))
    else
        nodes = getnodes(lt)
        noderecords = getnoderecords(lt)
    end
    return NodeTree{ND}(nodes,
                        empty ? Dict{Int, Branch{String}}() :
                        (deep ? deepcopy(getbranches(lt)) : getbranches(lt)),
                        leafrecords, noderecords)
end

function NodeTree{NodeData}(leaves::AbstractVector{String}, ::Type{NodeData})
    nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leaves))
    leafrecords = Dict(map(leaf -> leaf => TypedInfo(leaf), leaves))
    noderecords = Dict(map(leaf -> leaf => NodeData(), leaves))
    return NodeTree(nodes, Dict{Int, Branch{String}}(),
                    leafrecords, noderecords)
end

function NodeTree{NodeData}(numleaves::Int, ::Type{NodeData})
    leaves = map(num -> "Leaf $num", 1:numleaves)
    nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leaves))
    leafrecords = Dict(map(leaf -> leaf => TypedInfo(leaf), leaves))
    noderecords = Dict(map(leaf -> leaf => NodeData(), leaves))
    return NodeTree{NodeData}(nodes, Dict{Int, Branch{String}}(),
                              leafrecords, noderecords)
end

function _getnodes(nt::NodeTree)
    return nt.nodes
end

function _getbranches(nt::NodeTree)
    return nt.branches
end

function _getleafrecords(nt::NodeTree)
    return nt.leafrecords
end

function _getnoderecords(nt::NodeTree)
    return nt.noderecords
end

function _addnode!{NR}(tree::NodeTree{NR}, label)
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
    if Set(findleaves(tree) ∪ findunattacheds(tree)) !=
        Set(keys(_getleafrecords(tree)))
        warn("Leaf records do not match actual leaves of tree")
        return false
    end
    if Set(keys(_getnoderecords(tree))) !=
        Set(keys(_getnodes(tree)))
        warn("Leaf records do not match node records of tree")
        return false
    end
    return true
end

"""
    NamedTree

Binary phylogenetic tree object with known leaves
"""
const NamedTree = NodeTree{Void}

NamedTree(leaves::AbstractVector{String}) = NodeTree(leaves, Void)
NamedTree(numleaves::Int) = NodeTree(numleaves, Void)
