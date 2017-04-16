"""
    Node(Vector{Int}, Vector{Int}) <: AbstractNode

A node of phylogenetic tree
"""
type Node <: AbstractNode
    inbound::Vector{Int}
    outbound::Vector{Int}

    function Node(inbound::Vector{Int}, outbound::Vector{Int})
        all(inbound .> 0) && length(inbound) <= 1 ||
            error("Node must have at most one positive inbound branch number")
        all(outbound .> 0) ||
            error("Node must have positive outbound branch numbers")
        new(inbound, outbound)
    end
end

function Node()
    return Node(Int[], Int[])
end

function getinbounds(node::Node)
    return node.inbound
end

function getinbound(node::Node)
    return hasinbound(node) ? node.inbound[1] : 0
end

function setinbound!(node::Node, inbound::Int)
    push!(node.inbound, inbound)
end

function deleteinbound!(node::Node, inbound::Int)
    inbound ∈ node.inbound ? filter!(i -> i != inbound, node.inbound) :
        error("Node does not have inbound connection from branch $inbound")
end

function hasinbound(node::Node)
    return length(node.inbound) == 1
end

function getoutbounds(node::Node)
    return node.outbound
end

function addoutbound!(node::Node, outbound::Int)
    push!(node.outbound, outbound)
end

function deleteoutbound!(node::Node, outbound::Int)
    outbound ∈ node.outbound ? filter!(i -> i != outbound, node.outbound) :
        error("Node does not have outbound connection from branch $outbound")
end

function countoutbounds(node::Node)
    return length(node.outbound)
end

function outboundspace(::Node)
    return true
end

"""
    BinaryNode(Int, Vector{Int}) <: AbstractNode

A node of strict binary phylogenetic tree
"""
type BinaryNode <: AbstractNode
    inbound::Int
    outbound::Tuple{Int, Int}

    function BinaryNode(inbound::Int, outbound::Tuple{Int, Int})
        inbound >= 0 ||
            error("Inbound BinaryNode branch must be non-negative")
        all(outbound .>= 0) ||
            error("BinaryNode must have non-negative outbound branches")
        new(inbound, outbound)
    end
end

function BinaryNode()
    return BinaryNode(0, Int[])
end

function getinbounds(node::BinaryNode)
    return node.inbound == 0 ? Int[] : [node.in]
end

function getinbound(node::BinaryNode)
    return node.inbound
end

function setinbound!(node::BinaryNode, inbound::Int)
    node.inbound == 0 ? node.inbound = inbound :
        error("BinaryNode already has an inbound connection")
end

function deleteinbound!(node::BinaryNode, inbound::Int)
    node.inbound == inbound ? node.inbound = 0 :
        error("BinaryNode does not have inbound connection from branch $inbound")
end

function hasinbound(node::BinaryNode)
    return node.inbound != 0
end

function getoutbounds(node::BinaryNode)
    return node.outbound[1] == 0 ?
        (node.outbound[2] == 0 ? Int[] : [node.outbound[2]]) :
        node.outbound[2] == 0 ? [node.outbound[1]] : [node.outbound[1], node.outbound[2]]
end

function addoutbound!(node::BinaryNode, outbound::Int)
    node.outbound[1] == 0 ? node.outbound[1] = outbound :
        node.outbound[2] == 0 ? node.outbound[2] = outbound :
        error("BinaryNode already has two outbound connections")
end

function deleteoutbound!(node::BinaryNode, outbound::Int)
    node.outbound[1] == outbound ? node.outbound[1] = 0 :
        node.outbound[2] == outbound ? node.outbound[2] = 0 :
        error("BinaryNode does not have outbound connection to branch $outbound")
end

function countoutbounds(node::BinaryNode)
    return length(node.outbound)
end

function outboundspace(node::BinaryNode)
    return length(node.outbound) < 2
end

"""
    Branch

    A directed branch connecting two AbstractNodes of phylogenetic tree
"""
type Branch
    source::Int
    target::Int
    length::Float64

    function Branch(source::Int, target::Int, length::Float64)
        length >= 0.0 || isnan(length) ||
            error("Branch length must be positive or NaN (no recorded length)")
        source > 0 || target > 0 ||
            error("Source and target must be legal Node numbers")
        new(source, target, length)
    end
end

getsource(branch::Branch) = branch.source
gettarget(branch::Branch) = branch.target
getlength(branch::Branch) = branch.length

function checkbranch(id::Int, branch::Branch, tree::AbstractTree)
    return id > 0 &&
        getsource(branch) != gettarget(branch) &&
        !haskey(getbranches(tree), id) &&
        haskey(getnodes(tree), getsource(branch)) &&
        haskey(getnodes(tree), gettarget(branch)) &&
        !hasinbound(getnodes(tree)[gettarget(branch)]) &&
        outboundspace(getnodes(tree)[getsource(branch)])
end

"""
    Tree{<: AbstractNode, <: Branch} <: AbstractTree

Phylogenetic tree object
"""
type Tree{N <: AbstractNode} <: AbstractTree
    nodes::Dict{Int, N}
    branches::Dict{Int, Branch}
    
    function Tree{N}(nodes::Dict{Int, N}, branches::Dict{Int})
        if !isempty(nodes) || !isempty(branches)
            # We need to validate the connections
            Set(mapreduce(node -> hasinbound(node) ? getinbound(node) : 0,
                          (vec, next) -> next == 0 ? vec : push!(vec, next),
                          Int[], nodes)) == Set(keys(branches)) ||
                              error("$N inbound branches must exactly match Branch IDs")
            
            Set(mapreduce(getoutbounds, append!, nodes)) == Set(keys(branches)) ||
                error("$N outbound branches must exactly match Branch IDs")
            
            mapreduce(getsource, append!, branches) ⊆ Set(keys(branches)) ||
                error("$B sources must be $N IDs")
            
            mapreduce(getoutbounds, append!, nodes) ⊆ Set(keys(branches)) ||
                error("$B targets must be $N IDs")
        end
        return new(nodes, branches)
    end
end

const SimpleTree = Tree{Node}
SimpleTree() = SimpleTree(Dict{Int, Node}(), Dict{Int, Branch}())

const BinaryTree = Tree{BinaryNode}
BinaryTree() = BinaryTree(Dict{Int, BinaryNode}(), Dict{Int, Branch}())

function getnodes(tree::Tree)
    return tree.nodes
end
function getbranches(tree::Tree)
    return tree.branches
end
function getnodeinfo(::Tree)
    return nothing
end
function getbranchinfo(::Tree)
    return nothing
end

"""
    ParameterisedTree{<: AbstractNode,
                      <: AbstractNodeInfo, <: AbstractBranchInfo} <: AbstractTree

Parametric phylogenetic tree object
"""
type ParameterisedTree{N  <: AbstractNode,
                       NI <: AbstractNodeInfo, BI <: AbstractBranchInfo} <: AbstractTree
    nodes::Dict{Int, N}
    branches::Dict{Int, Branch}
    nodeinfo::Dict{Int, NI}
    branchinfo::Dict{Int, BI}
    
    function ParameterisedTree{N, NI, BI}(nodes::Dict{Int, N},
                                          branches::Dict{Int, Branch},
                                          nodeinfo::Dict{Int, NI},
                                          branchinfo::Dict{Int, BI})
        if !isempty(nodes) || !isempty(branches)
            # Otherwise we need to validate the connections
            Set(keys(nodeinfo)) ⊆ Set(keys(nodes)) ||
                error("$NI Dict keys must be in $N Dict keys")

            Set(keys(branchinfo)) ⊆ Set(keys(branches)) ||
                error("$BI Dict keys must be in Branch Dict keys")
            
            Set(mapreduce(node -> hasinbound(node) ? getinbound(node) : 0,
                          (vec, next) -> next == 0 ? vec : push!(vec, next),
                          Int[], nodes)) == Set(keys(branches)) ||
                              error("$N inbound branches must exactly match Branch IDs")
            
            Set(mapreduce(getoutbounds, append!, nodes)) == Set(keys(branches)) ||
                error("$N outbound branches must exactly match Branch IDs")
            
            mapreduce(getsource, append!, branches) ⊆ Set(keys(branches)) ||
                error("Branch sources must be $N IDs")
            
            mapreduce(getoutbounds, append!, nodes) ⊆ Set(keys(branches)) ||
                error("Branch targets must be $N IDs")
        end
        return new(nodes, branches, nodeinfo, branchinfo)
    end
end

nodetype(pt::ParameterisedTree) = valtype(pt.nodes)
nodeinfotype(pt::ParameterisedTree) = valtype(pt.nodeinfo)
branchinfotype(pt::ParameterisedTree) = valtype(pt.branchinfo)

function ParameterisedTree{N <: AbstractNode,
                           BI <: AbstractBranchInfo}(nodes::Dict{Int, N},
                                                     branches::Dict{Int, Branch},
                                                     branchinfo::Dict{Int, BI})
    return ParameterisedTree{N, VoidNodeInfo, BI}(nodes,
                                                  branches,
                                                  map((k, v) -> (k, VoidNodeInfo()),
                                                      nodes),
                                                  branchinfo)
end
    
function ParameterisedTree{N <: AbstractNode,
                           NI <: AbstractNodeInfo}(nodes::Dict{Int, N},
                                                   branches::Dict{Int, Branch},
                                                   nodeinfo::Dict{Int, NI})
    return ParameterisedTree{N, NI, VoidBranchInfo}(nodes,
                                                    branches,
                                                    nodeinfo,
                                                    map((k, v) -> (k, VoidBranchInfo()),
                                                        branches))
end

function ParameterisedTree{BI <: AbstractBranchInfo}(branchinfo::Dict{Int, BI})
    return ParameterisedTree{BinaryNode,
                             VoidNodeInfo, BI}(Dict{Int, BinaryNode}(),
                                               Dict{Int, Branch}(),
                                               Dict{Int, VoidNodeInfo}(),
                                               branchinfo)
end
    
function ParameterisedTree{NI <: AbstractNodeInfo}(nodeinfo::Dict{Int, NI})
    return ParameterisedTree{BinaryNode, NI,
                             VoidBranchInfo}(Dict{Int, BinaryNode}(),
                                             Dict{Int, Branch}(),
                                             nodeinfo,
                                             Dict{Int, VoidBranchInfo}())
end

function ParameterisedTree(pt::ParameterisedTree; deep=true, empty=true)
    return ParameterisedTree{nodetype(pt),
                             nodeinfotype(pt),
                             branchinfotype(pt)}(empty ? Dict{Int, nodetype(pt)}() :
                                                 deep ? deepcopy(pt.nodes) : pt.nodes,
                                                 empty ? Dict{Int, Branch}() :
                                                 deep ? deepcopy(pt.branches) : pt.branches,
                                                 deep ? deepcopy(pt.nodeinfo) : pt.nodeinfo,
                                                 deep ? deepcopy(pt.branchinfo) : pt.branchinfo)
end

function getnodes(pt::ParameterisedTree)
    return pt.nodes
end
function getbranches(pt::ParameterisedTree)
    return pt.branches
end
function getnodeinfo(pt::ParameterisedTree)
    return pt.nodeinfo
end
function getbranchinfo(pt::ParameterisedTree)
    return pt.branchinfo
end
