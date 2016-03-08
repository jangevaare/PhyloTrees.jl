"""
Phylogenetic tree object
"""
type Tree
  nodes::Vector{Node}
  branches::Vector{Branch}
  Tree() = new()
end


"""
Node of phylogenetic tree
"""
type Node
  id::Int64
  seq::Array{Float64,2}
  in_branches::Vector{Int64}
  out_branches::Vector{Int64}
end


"""
Directed branch connecting two nodes of phylogenetic tree
"""
type Branch
  id::Int64
  length::Float64
  source::Int64
  target::Int64
end


"""
Add a branch
"""
function AddBranch!(tree::Tree, length::Float64, source::Int64, target::Int64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)
  if node_count <= 1
    error("Tree requires at least 2 nodes to form a branch")
  end
  if !(1 <= source <= node_count)
    error("Invalid branch source node specified")
  end
  if !(1 <= target <= node_count)
    error("Invalid branch target node specified")
  end
  if length <= 0
    error("Branch length must be positive")
  end
  if branch_count == 0
    tree.branches = [Branch(1, length, source, target)]
  else
    push!(tree.branches, Branch(branch_count+1, length, source, target))
  end
  if length(tree.nodes[source].out_branches) == 0
    tree.nodes[source].out_branches = tree.branches[end].id
  else
    push!(tree.nodes[source].out_branches, tree.branches[end].id)
  end
  if length(tree.nodes[target].in_branches) == 0
    tree.nodes[target.in_branches = [tree.branches[end].id]
  else
    push!(tree.nodes[target].in_branches, tree.branches[end].id)
    warn("The in degree of the target node is >1")
  end
  return tree
end


"""
Add a node with a specified sequence
"""
function AddNode!(tree::Tree, seq::Array{Float64, 2})
end


"""
Add a node without a specified sequence
"""
function AddNode!(tree::Tree)
end


"""
Function to visit nodes of phylogenetic tree with preorder traversal
"""
function postorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  while !all(visited)
  end
end

"""
Function to visit nodes of phylogenetic tree with postorder traversal
"""
function postorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  while !all(visited)
  end
end
