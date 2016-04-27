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
function findroots(tree::Tree)
  root = Int64[]
  for i in 1:length(tree.nodes)
    if isroot(tree.nodes[i])
      push!(root, i)
    end
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


"""
Node pathway through which a specified node connects to a root
"""
function nodepath(tree::Tree, node::Int64)
  if !(1 <= node <= length(tree.nodes))
    error("Invalid node specified")
  end
  path = [node]
  while !isroot(tree.nodes[pathway[end]])
    push!(path, tree.branches[tree.nodes[pathway[end]].in].source)
  end
  return path
end


"""
Node pathway through which two specified nodes connect
"""
function nodepath(tree::Tree, node1::Int64, node2::Int64)
  if !(1 <= node1 <= length(tree.nodes))
    error("Invalid node specified")
  end
  if !(1 <= node2 <= length(tree.nodes))
    error("Invalid node specified")
  end
  path1 = reverse(nodepath(tree, node1))
  path2 = reverse(nodepath(tree, node2))
  if path1[1] !== path2[1]
    error("Nodes are not connected")
  else
    minlength = minimum(length(path1), length(path2))
    mrca_index = findlast(path1[1:minlength] .== path2[1:minlength])
    return [reverse(path1[(mrca_index+1):end]); path2[mrca_index:end]]
  end
end


"""
The root associated with a specified node
"""
function noderoot(tree:Tree, node::Int64)
  return nodepath(tree, node)[end]
end


"""
Branch pathway through which a specified node connects to a root
"""
function branchpath(tree::Tree, node::Int64)
  if !(1 <= node <= length(tree.nodes))
    error("Invalid node specified")
  end
  path = []
  while !isroot(tree.nodes[node])
    push!(path, tree.nodes[pathway[end]].in)
    node = tree.branches[path[end]].in
  end
  return path
end


"""
Branch pathway through which two specified nodes connect
"""
function branchpath(tree::Tree, node1::Int64, node2::Int64)
  if !(1 <= node1 <= length(tree.nodes))
    error("Invalid node specified")
  end
  if !(1 <= node2 <= length(tree.nodes))
    error("Invalid node specified")
  end
  if noderoot(tree, node1) !== noderoot(tree, node2)
    error("Nodes are not connected")
  end
  path1 = reverse(branchpath(tree, node1))
  path2 = reverse(branchpath(tree, node2))
  minlength = minimum(length(path1), length(path2))
  if minlength == 0
    mrcb_index = 0
  else
    mrcb_index = findlast(path1[1:minlength] .== path2[1:minlength])
  end
  return [reverse(path1[(mrcb_index+1):end]); path2[mrcb_index+1:end]]
end
