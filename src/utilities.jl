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
Is a particular node a root?
"""
function isroot(tree::Tree, node::Int64)
  if !(1 <= node <= length(tree.nodes))
    error("Invalid node specified")
  end
  return isroot(tree.nodes[node])
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
Is a particular node a leaf?
"""
function isleaf(tree::Tree, node::Int64)
  if !(1 <= node <= length(tree.nodes))
    error("Invalid node specified")
  end
  return isleaf(tree.nodes[node])
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
Is a particular node an internal node?
"""
function isnode(tree::Tree, node::Int64)
  if !(1 <= node <= length(tree.nodes))
    error("Invalid node specified")
  end
  return isnode(tree.nodes[node])
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
Check if a node index is valid
"""
function validnode(tree::Tree, node::Int64)
  return 1 <= node <= length(tree.nodes)
end


"""
Check if a node index is valid
"""
function validnode(tree::Tree, nodes::Vector{Int64})
  return all(1 .<= nodes .<= length(tree.nodes))
end


"""
Find the parent node of a specified node
"""
function parentnode(tree::Tree, node::Int64)
  if !validnode(tree, node)
    error("Invalid node specified")
  end
  return tree.branches[tree.nodes[node].in].source
end


"""
Node pathway through which a specified node connects to a root
"""
function nodepath(tree::Tree, node::Int64)
  if !validnode(tree, node)
    error("Invalid node specified")
  end
  path = [node]
  while !isroot(tree, pathway[end])
    push!(path, parentnode(tree, pathway[end]))
  end
  return path
end


"""
The root associated with a specified node
"""
function noderoot(tree::Tree, node::Int64)
  return nodepath(tree, node)[end]
end


"""
Check for connectedness of two nodes
"""
function areconnected(tree::Tree, node1::Int64, node2::Int64)
  return noderoot(tree, node1) == noderoot(tree, node2)
end


"""
Node pathway through which two specified nodes connect
"""
function nodepath(tree::Tree, node1::Int64, node2::Int64)
  if !validnode(tree, [node1; node2])
    error("Invalid node specified")
  end
  path1 = reverse(nodepath(tree, node1))
  path2 = reverse(nodepath(tree, node2))
  if !areconnected(tree, node1, node2)
    error("Nodes are not connected")
  end
  minlength = minimum(length(path1), length(path2))
  mrcnode_index = findlast(path1[1:minlength] .== path2[1:minlength])
  return [reverse(path1[(mrcnode_index+1):end]); path2[mrcnode_index:end]]
end


"""
Branch pathway through which a specified node connects to a root
"""
function branchpath(tree::Tree, node::Int64)
  path = []
  while !isroot(tree, node)
    push!(path, tree.nodes[node].in)
    node = tree.branches[path[end]].in
  end
  return path
end


"""
Branch pathway through which two specified nodes connect
"""
function branchpath(tree::Tree, node1::Int64, node2::Int64)
  if !areconnected(tree, node1, node2)
    error("Nodes are not connected")
  end
  path1 = reverse(branchpath(tree, node1))
  path2 = reverse(branchpath(tree, node2))
  minlength = minimum(length(path1), length(path2))
  if minlength == 0
    mrcbranch_index = 0
  else
    mrcbranch_index = findlast(path1[1:minlength] .== path2[1:minlength])
  end
  return [reverse(path1[(mrcbranch_index+1):end]); path2[mrcbranch_index+1:end]]
end
