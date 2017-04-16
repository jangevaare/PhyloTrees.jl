using Compat

@compat abstract type AbstractNode end

function getinbounds end

function getinbound end

function setinbound end

function hasinbound end

isroot(node::AbstractNode) = !hasinbound(node)

function getoutbounds end

function setoutbound end

function countoutbounds end

isleaf(node::AbstractNode) = countoutbounds(node) == 0

function outboundspace end

@compat abstract type AbstractNode end

function getinbounds end

@compat abstract type AbstractInfo{Label} end

function getlabel end

function haslabel end

function haslabel{I <: AbstractInfo}(dict::Dict{Int, I}, label)
    !isempty(filter((k, v) -> getlabel(v) == label, dict))
end
function haslabel{I <: AbstractInfo{Void}}(dict::Dict{Int, I}, label)
    false
end

function getid end

function getid{I <: AbstractInfo}(dict::Dict{Int, I}, label)
    first(keys(filter((k, v) -> getlabel(v) == label, dict)))
end
function getid{I <: AbstractInfo{Void}}(dict::Dict{Int, I}, label)
    throw(BoundsError(Void))
end

@compat abstract type AbstractNodeInfo{Label} <: AbstractInfo{Label} end
immutable VoidNodeInfo <: AbstractNodeInfo{Void} end
immutable NodeInfo{T} <: AbstractNodeInfo{T}
    info::T
end
function getlabel(ni::NodeInfo)
    return ni.info
end


@compat abstract type AbstractBranchInfo{Label} <: AbstractInfo{Label} end
immutable VoidBranchInfo <: AbstractBranchInfo{Void} end
immutable BranchInfo{T} <: AbstractBranchInfo{T}
    info::T
end
function getlabel(bi::BranchInfo)
    return bi.info
end

@compat abstract type AbstractTree end

function checknodeinfo end

function checknodeinfo{BI <: AbstractNodeInfo}(id::Int, dict::Dict{Int, BI})
    return haskey(dict, id)
end
function checknodeinfo(::Int, ::Dict{Int, VoidNodeInfo})
    return true
end
function checknodeinfo(::Int, ::Void)
    return true
end

function checknode end

function checknode(id::Int, node::AbstractNode, tree::AbstractTree)
    return id > 0 && !haskey(getnodes(tree), id) &&
        (!hasinbound(node) || (haskey(getbranches(tree), getinbound(node)) &&
                               gettarget(getbranches(tree)[getinbound(node)]) == id)) &&
                               getoutbounds(node) ⊆ keys(getbranches(tree)) &&
                               all(branch -> getsource(getnodes(tree)[branch]) == id,
                                   getoutbounds(node))
end

function getnodes end
function getbranches end
function getnodeinfo end
function getbranchinfo end

function checkbranchinfo end

function checkbranchinfo{BI <: AbstractBranchInfo}(id::Int, dict::Dict{Int, BI})
    return haskey(dict, id)
end
function checkbranchinfo(::Int, ::Dict{Int, VoidBranchInfo})
    return true
end
function checkbranchinfo(::Int, ::Void)
    return true
end

function checkbranch end

function hasinbound(tree::AbstractTree, node::Int)
    hasinbound(getnodes(tree)[node])
end
function getinbound(tree::AbstractTree, node::Int)
    getinbound(getnodes(tree)[node])
end
function getinbounds(tree::AbstractTree, node::Int)
    getinbounds(getnodes(tree)[node])
end
function getoutbounds(tree::AbstractTree, node::Int)
    getoutbounds(getnodes(tree)[node])
end
function countoutbounds(tree::AbstractTree, node::Int)
    countoutbounds(getnodes(tree)[node])
end
function getsource(tree::AbstractTree, branch::Int)
    gettarget(getbranches(tree)[branch])
end
function gettarget(tree::AbstractTree, branch::Int)
    gettarget(getbranches(tree)[branch])
end
