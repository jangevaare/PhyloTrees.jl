"""
A parametric node of phylogenetic tree
"""
type Node
  in::Vector{Int64}
  out::Vector{Int64}

  function Node()
    new(Int64[], Int64[])
  end
end


"""
A directed parametric branch connecting two nodes of phylogenetic tree
"""
type Branch
  source::Int64
  target::Int64
  length::Float64

  function Branch(source::Int64, target::Int64, length::Float64)
    if length < 0.
      error("Branch length must be positive")
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
type Tree
  nodes::Dict{Int64, Node}
  branches::Dict{Int64, Branch}

  Tree() = new(Dict{Int64, Node}(), Dict{Int64, Branch}())
end
