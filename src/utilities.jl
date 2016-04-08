"""
Is a particular node a root?
"""
function isroot(node::Node)
  if length(node.out) > 0 && length(node.in) == 0
    return true
  else
    return false
  end
end


"""
Is a particular node a leaf?
"""
function isleaf(node::Node)
  if length(node.out) == 0 && length(node.in) == 1
    return true
  else
    return false
  end
end


"""
Is a particular node an internal node?
"""
function isnode(node::Node)
  if length(node.out) > 0 && length(node.in) == 1
    return true
  else
    return false
  end
end


"""
The first encountered root of a phylogenetic tree
"""
function findroot(tree::Tree)
  root = Int64[]
  for i in 1:length(tree.nodes)
    if isroot(tree.nodes[i])
      push!(root, i)
    end
    length(root) > 0 && break
  end
  if length(root) == 0
    warn("No roots detected")
  end
  return root
end


"""
Find the leaves of a phylogenetic tree
"""
function findleaves(tree::Tree)
  leaves = Int64[]
  for i in 1:length(tree.nodes)
    if isleaf(tree.nodes[i])
      push!(leaves, i)
    end
  end
  if length(leaves) == 0
    warn("No leaves detected")
  end
  return leaves
end


"""
Find the internal nodes of a phylogenetic tree
"""
function findnodes(tree::Tree)
  nodes = Int64[]
  for i in 1:length(tree.nodes)
    if isnode(tree.nodes[i])
      push!(nodes, i)
    end
  end
  if length(nodes) == 0
    warn("No internal nodes detected")
  end
  return nodes
end
