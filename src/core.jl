abstract TreeComponent

"""
A parametric node of phylogenetic tree
"""
type Node{N} <: TreeComponent
  label::Nullable{String}
  in::Vector{Int64}
  out::Vector{Int64}
  data::Nullable{N}

  function Node()
    new(Nullable{String}(), Int64[], Int64[], Nullable())
  end

  function Node(label::String)
    new(Nullable(label), Int64[], Int64[], Nullable())
  end
end


"""
A directed parametric branch connecting two nodes of phylogenetic tree
"""
type Branch{B} <: TreeComponent
  source::Int64
  target::Int64
  length::Float64
  data::Nullable{B}

  function Branch(source::Int64, target::Int64, length::Float64)
    if length < 0.
      error("Branch length must be positive")
    end
    new(source, target, length, Nullable())
  end

  function Branch(source::Int64, target::Int64)
    new(source, target, NaN, Nullable())
  end
end


"""
Parametric phylogenetic tree object
"""
type Tree{N, B}
  nodes::Vector{Node{N}}
  branches::Vector{Branch{B}}

  Tree() = new(Node{N}[], Branch{B}[])
end
