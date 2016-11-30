"""
Phylogenetic tree object
"""
type Tree{N, B}
  nodes::Vector{Node{N}}
  branches::Vector{Branch{B}}

  Tree() = new(Node{N}[], Branch{B}[])

  Tree(nodes::Vector{Node}, branches::Vector{Branch}) = new(nodes, branches)
end


function show(io::IO, object::Tree)
  print(io, "\r\e[0mPhylogenetic tree with $(length(object.nodes)) nodes and $(length(object.branches)) branches")
end
