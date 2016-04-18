"""
Node of phylogenetic tree
"""
type Node
  in::Vector{Int64}
  out::Vector{Int64}

  Node() = new(Int64[], Int64[])
end


"""
Directed branch connecting two nodes of phylogenetic tree
"""
type Branch
  source::Int64
  target::Int64
  length::Float64
end


"""
Phylogenetic tree object
"""
type Tree
  nodes::Vector{Node}
  branches::Vector{Branch}

  Tree() = new([Node()], Branch[])
end


import Base.show


function show(io::IO, object::Tree)
  println(io, "Phylogenetic tree with $(length(object.nodes)) nodes and $(length(object.branches)) branches")
end


"""
Add a node
"""
function addnode!(tree::Tree)
  push!(tree.nodes, Node())
  return tree
end


"""
Add a branch
"""
function addbranch!(tree::Tree,
                    source::Int64,
                    target::Int64,
                    branch_length::Float64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  if node_count <= 1
    error("Tree requires at least 2 nodes to form a branch")
  end
  if !(1 <= source <= node_count)
    error("Invalid source node specified")
  end
  if !(1 <= target <= node_count)
    error("Invalid target node specified")
  end
  if target == source
    error("Branch must connect unique nodes")
  end
  if branch_length <= 0.
    error("Branch length must be positive")
  end

  # Warnings
  if length(tree.nodes[target].in) == 1
    warn("The in degree of the target node is > 1")
  end

  # Add branch
  push!(tree.branches, Branch(source, target, branch_length))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out, length(tree.branches))
  push!(tree.nodes[target].in, length(tree.branches))

  # Return updated tree
  return tree
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64,
                 branch_length::Float64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  if node_count == 0
    error("Tree requires at least 2 nodes to form a branch")
  end
  if !(1 <= source <= node_count)
    error("Invalid source node specified")
  end
  if branch_length <= 0.
    error("Branch length must be positive")
  end

  # Add node
  push!(tree.nodes, Node())

  # Add branch
  push!(tree.branches, Branch(source, node_count+1, branch_length))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out, length(tree.branches))
  push!(tree.nodes[node_count+1].in, length(tree.branches))

  # Return updated tree
  return tree
end
