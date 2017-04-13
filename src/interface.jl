using Compat

@compat abstract type AbstractNode end

function getinbounds end

function getinbound end

function hasinbound end

isroot(node::AbstractNode) = !hasinbound(node)

function getoutbounds end

function getoutbound end

function countoutbounds end

isleaf(node::AbstractNode) = countoutbounds(node) == 0

@compat abstract type AbstractNode end

function getinbounds end

@compat abstract type AbstractInfo{Label} end

function getlabel end

function haslabel end

function haslabel{I <: AbstractInfo}(dict::Dict{UInt, I}, label)
    !isempty(filter((k, v) -> getlabel(v) == label, dict))
end
function haslabel{I <: AbstractInfo{Void}}(dict::Dict{UInt, I}, label)
    false
end

function getid end

function getid{I <: AbstractInfo}(dict::Dict{UInt, I}, label)
    keys(filter((k, v) -> getlabel(v) == label, dict))[1]
end
function getid{I <: AbstractInfo{Void}}(dict::Dict{UInt, I}, label)
    throw(BoundsError(Void))
end

@compat abstract type AbstractNodeInfo{Label} <: AbstractInfo{Label} end

@compat abstract type AbstractBranchInfo{Label} <: AbstractInfo{Label} end

@compat abstract type AbstractTree end

