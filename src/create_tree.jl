"""
Node of phylogenetic tree
"""
type Node
  seq::Array{Float64,2}
  in_branches::Vector{Int64}
  out_branches::Vector{Int64}
end


"""
Directed branch connecting two nodes of phylogenetic tree
"""
type Branch
  length::Float64
  rate::Float64
  source::Int64
  target::Int64
end

Branch(branch_length::Float64, source::Int64, target::Int64) = Branch(branch_length, 1.0, source, target)

"""
Phylogenetic tree object
"""
type Tree
  nodes::Vector{Node}
  branches::Vector{Branch}
  site_rates::Vector{Float64}

  Tree(sites::Int64) = new(Node[], Branch[], fill(1.0, sites))
  Tree(site_rates::Vector{Float64}) = new(Node[], Branch[], site_rates)
end


"""
Add a node with a specified sequence
"""
function add_node!(tree::Tree, seq::Array{Float64, 2})
  if size(seq, 2) !== length(tree.site_rates)
    error("Mismatch in sequence length and site rates")
  end
  push!(tree.nodes, Node(seq, Int64[], Int64[]))
  return tree
end


"""
Add a node without a specified sequence
"""
add_node!(tree::Tree) = add_node!(tree, fill(0., (4, length(tree.site_rates))))


"""
Add a branch
"""
function add_branch!(tree::Tree, branch_length::Float64, rate::Float64, source::Int64, target::Int64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  if rate < 0
    error("Rate must be positive")
  end
  if node_count <= 1
    error("Tree requires at least 2 nodes to form a branch")
  end
  if !(1 <= source <= node_count)
    error("Invalid branch source node specified")
  end
  if !(1 <= target <= node_count)
    error("Invalid branch target node specified")
  end
  if branch_length <= 0.
    error("Branch length must be positive")
  end

  # Add the branch
  push!(tree.branches, Branch(branch_length, source, target))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out_branches, length(tree.branches))
  push!(tree.nodes[target].in_branches, length(tree.branches))

  if length(tree.nodes[target].in_branches) > 1
    warn("The in degree of the target node is > 1")
  end

  return tree
end


add_branch!(tree::Tree, branch_length::Float64, source::Int64, target::Int64) = add_branch!(tree, branch_length, source, target)
