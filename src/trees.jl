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
Phylogenetic tree object
"""
type Tree
  nodes::Vector{Node}
  branches::Vector{Branch}
  Tree(Node[], Branch[]) = new()
end

"""
Add a node with a specified sequence
"""
function add_node!(tree::Tree, seq::Array{Float64, 2})
  node_count = length(tree.nodes)
  if node_count == 0
    tree.nodes = [Node(1, seq, Int64[], Int64[])]
  else
    push!(tree.nodes, Node(tree.nodes[node_count].id + 1, seq, Int64[], Int64[]))
  end
  return tree
end


"""
Add a node without a specified sequence
"""
add_node!(tree::Tree, length::Int64) = add_node!(tree, fill(0., (4,length)))


"""
Remove a node
"""
function remove_node!(tree::Tree, node_id::Int64)
end


"""
Add a branch
"""
function add_branch!(tree::Tree, length::Float64, source::Int64, target::Int64)
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
    push!(tree.branches, Branch(tree.branches[branch_count].id + 1, length, source, target))
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
Remove a branch
"""
function remove_branch!(tree::Tree, branch_id::Int64)
end


"""
The first encountered root of a phylogenetic tree
"""
function findroot(tree::Tree)
  root = Int64[]
  for i in tree.nodes
    if length(i.in_branches) == 0
      push!(root, i.id)
    end
    length(root) > 0 && break
  end
  if length(root) == 0
    warn("No roots detected")
  else
    return root[1]
  end
end


"""
Find the leaves of a phylogenetic tree
"""
function findleaves(tree::Tree)
  leaves = Int64[]
  for i in tree.nodes
    if length(i.out_branches) == 0
      push!(leaves, i.id)
    end
  end
  if length(leaves) == 0
    warn("No leaves detected")
  else
    return leaves
  end
end


"""
Function to visit nodes of phylogenetic tree with preorder traversal
"""
function postorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  i = tree.nodes[1]
  while !all(visited)
    for j in tree.branches[i.out_branches]
      visited[j.target]

    if all(visted[])


"""
Function to visit nodes of phylogenetic tree with postorder traversal
"""
function preorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  while !all(visited)
  end
end
