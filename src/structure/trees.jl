"""
Phylogenetic tree object
"""
type Tree
  nodes::Vector{Node}
  branches::Vector{Branch}

  Tree() = new([Node()], Branch[])

  Tree(nodes::Vector{Node}, branches::Vector{Branch}) = new(nodes, branches)

  function Tree(nodes::Int64)
    if nodes < 0
      throw("Invalid number of nodes specified")
    end
    tree = new(Node[], Branch[])
    for i = 1:nodes
      push!(tree.nodes, Node())
    end
    return tree
  end

end


function show(io::IO, object::Tree)
  print(io, "\r\e[0mPhylogenetic tree with $(length(object.nodes)) nodes and $(length(object.branches)) branches")
end
