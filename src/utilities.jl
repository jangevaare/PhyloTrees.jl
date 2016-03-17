"""
Is a particular node a root?
"""
function is_root(node::Node)
  if length(node.out_branches) > 0 && length(node.in_branches) == 0
    return true
  else
    return false
  end
end


"""
Is a particular node a leaf?
"""
function is_leaf(node::Node)
  if length(node.out_branches) == 0 && length(node.in_branches) == 1
    return true
  else
    return false
  end
end


"""
Is a particular node an internal node?
"""
function is_node(node::Node)
  if length(node.out_branches) > 0 && length(node.in_branches) == 1
    return true
  else
    return false
  end
end


"""
The first encountered root of a phylogenetic tree
"""
function find_root(tree::Tree)
  root = Int64[]
  for i in tree.nodes
    if is_root(i)
      push!(root, i.id)
    end
    length(root) > 0 && break
  end
  if length(root) == 0
    warn("No roots detected")
  else
    return root
  end
end


"""
Find the leaves of a phylogenetic tree
"""
function find_leaves(tree::Tree)
  leaves = Int64[]
  for i in tree.nodes
    if is_leaf(i)
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
Find the internal nodes of a phylogenetic tree
"""
function find_nodes(tree::Tree)
  nodes = Int64[]
  for i in tree.nodes
    if is_node(i)
      push!(nodes, i.id)
    end
  end
  if length(nodes) == 0
    warn("No internal nodes detected")
  else
    return nodes
  end
end


"""
Check for a valid phylogenetic tree topology
"""
function check_tree(tree::Tree)
  if length(find_root(tree)) > 1
    warn("Multiple roots detected")
  end
  if length(find_leaves(tree)) - 1 !== length(find_nodes(tree))
    warn("Unexpected quantity of internal nodes (assuming bifurcating tree)")
  end
  for i = 1:length(tree.nodes)
    if length(tree.nodes[i].out_branches) > 2
      warn("out degree of node $i > 2")
    end
    if length(tree.nodes[i].in_branches) > 1
      warn("in degree of node $i > 1")
    end
    if size(tree.nodes[i].seq) !== (4, length(tree.site_rates))
      warn("Unexpected sequence dimensions at node $i")
    end
  end
  info("Check of phylogenetic tree complete")
end
