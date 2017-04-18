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
    NamedTree

Binary phylogenetic tree object with known leaves
"""
type NamedTree <: AbstractTree{String, Int}
    nodes::Dict{String, BinaryNode{Int}}
    branches::Dict{Int, Branch{String}}
    leafrecords::Dict{String, TypedInfo{String}}
end

function NamedTree(lt::NamedTree; deep=true, empty=true)
    verify(lt) || error("Tree to copy is not valid")
    leafrecords = deep ? deepcopy(getleafrecords(lt)) : getleafrecords(lt)
    nodes = getnodes(lt)
    if empty
        nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), keys(leafrecords)))
    elseif deep
        nodes = deepcopy(nodes)
    end
    return NamedTree(nodes,
                    empty ? Dict{Int, Branch{String}}() :
                    (deep ? deepcopy(getbranches(lt)) : getbranches(lt)),
                    leafrecords)
end

function NamedTree(leaves::AbstractVector{String})
    leafrecords = Dict(map(leaf -> leaf => TypedInfo(leaf), leaves))
    nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leaves))
    return NamedTree(nodes, Dict{Int, Branch{String}}(), leafrecords)
end

function NamedTree(numleaves::Int)
    leaves = map(num -> "Leaf $num", 1:numleaves)
    leafrecords = Dict(map(leaf -> leaf => TypedInfo(leaf), leaves))
    nodes = Dict(map(leaf -> leaf => BinaryNode{Int}(), leaves))
    return NamedTree(nodes, Dict{Int, Branch{String}}(), leafrecords)
end

function _getnodes(pt::NamedTree)
    return pt.nodes
end

function _getbranches(pt::NamedTree)
    return pt.branches
end

function _getleafrecords(pt::NamedTree)
    return pt.leafrecords
end

function _addnode!(tree::NamedTree, label)
    setnode!(tree, label, BinaryNode{Int}())
    return label
end

function _verify(tree::NamedTree)
    if Set(findleaves(tree) ∪ findunattacheds(tree)) !=
        Set(keys(_getleafrecords(tree)))
        warn("Leaf records do not match actual leaves of tree")
        return false
    end 
    return true
end
