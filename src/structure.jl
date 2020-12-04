"""
A parametric node of phylogenetic tree
"""
struct Node
  in::Vector{Int64}
  out::Vector{Int64}

  function Node()
    new(Int64[], Int64[])
  end
end


"""
A directed parametric branch connecting two nodes of phylogenetic tree
"""
struct Branch
  source::Int64
  target::Int64
  length::Float64

  function Branch(source::Int64, target::Int64, length::Float64)
    if length < 0.
      error("Branch length is < 0.0")
    end
    new(source, target, length)
  end

  function Branch(source::Int64, target::Int64)
    new(source, target, NaN)
  end
end


"""
Parametric phylogenetic tree object
"""
struct Tree
  nodes::Dict{Int64, Node}
  branches::Dict{Int64, Branch}
  height::Float64
  node_to_label::Dict{Int64, Symbol}
  label_to_node::Dict{Symbol, Int64}

  Tree() = new(Dict{Int64, Node}(), Dict{Int64, Branch}(), 0.0, Dict{Int64, Symbol}(), Dict{Symbol, Int64}())
  Tree(x::Float64) = new(Dict{Int64, Node}(), Dict{Int64, Branch}(), x, Dict{Int64, Symbol}(), Dict{Symbol, Int64}())
end
