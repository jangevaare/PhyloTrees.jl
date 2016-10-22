"""
Check if a node index is valid
"""
function validnode(tree::Tree,
                   node::Int64)
  if 1 <= node <= length(tree.nodes)
    return true
  else
    error("An invalid node has been specified")
  end
end


"""
Check if a node index is valid
"""
function validnodes(tree::Tree,
                    nodes::Array{Int64})
  for i in nodes
    validnode(tree, i)
  end
end


"""
Check if a branch index is valid
"""
function validbranch(tree::Tree,
                     branch::Int64)
  if 1 <= branch <= length(tree.branches)
    return true
  else
    error("An invalid branch has been specified")
  end
end


"""
Check if a branch index is valid
"""
function validbranches(tree::Tree,
                       branches::Array{Int64})
  for i in branches
    validbranch(tree, i)
  end
end


"""
Returns the in degree of a node
"""
function indegree(node::Node)
  return length(node.in)
end


"""
Returns the in degree of a node
"""
function indegree(tree::Tree,
                  node::Int64)
  validnode(tree, node)
  return indegree(tree.nodes[node])
end


"""
Returns the out degree of a node
"""
function outdegree(node::Node)
  return length(node.out)
end


"""
Returns the out degree of a node
"""
function outdegree(tree::Tree,
                   node::Int64)
  validnode(tree, node)
  return outdegree(tree.nodes[node])
end


"""
Is a particular node a root?
"""
function isroot(node::Node)
  if outdegree(node) > 0 && indegree(node) == 0
    return true
  else
    return false
  end
end


"""
Is a particular node a root?
"""
function isroot(tree::Tree, node::Int64)
  validnode(tree, node)
  return isroot(tree.nodes[node])
end


"""
Is a particular node a leaf?
"""
function isleaf(node::Node)
  if outdegree(node) == 0 && indegree(node) == 1
    return true
  else
    return false
  end
end


"""
Is a particular node a leaf?
"""
function isleaf(tree::Tree, node::Int64)
  validnode(tree, node)
  return isleaf(tree.nodes[node])
end


"""
Is a particular node an internal node?
"""
function isnode(node::Node)
  if outdegree(node) > 0 && indegree(node) == 1
    return true
  else
    return false
  end
end


"""
Is a particular node an internal node?
"""
function isnode(tree::Tree, node::Int64)
  validnode(tree, node)
  return isnode(tree.nodes[node])
end


"""
Is a node an internal node, a root node, or a leaf
"""
function nodetype(node::Node)
  ins = indegree(node)
  outs = outdegree(node)
  if ins == 0
    if outs == 0
      return "Unattached"
    else
      return "Root"
    end
  elseif ins == 1
    if outs == 0
      return "Leaf"
    elseif outs > 0
      return "Internal"
    else
      error("Unknown node type")
    end
  else
    error("Unknown node type")
  end
end


"""
Is a node an internal node, a root node, or a leaf
"""
function nodetype(tree::Tree, node::Int64)
  if validnode(tree, node)
    return nodetype(tree.nodes[node])
  end
end


"""
Find the roots of a phylogenetic tree
"""
function findroots(tree::Tree)
  roots = Int64[]
  for i in 1:length(tree.nodes)
    if isroot(tree, i)
      push!(roots, i)
    end
  end
  if length(roots) == 0
    warn("No roots detected")
  end
  return roots
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
Find the nonroots of a phylogenetic tree
"""
function findnonroots(tree::Tree)
  nonroots = Int64[]
  for i in 1:length(tree.nodes)
    if !isroot(tree, i)
      push!(nonroots, i)
    end
  end
  if length(nonroots) == 0
    warn("No non-roots detected")
  end
  return nonroots
end


"""
Find the non-leaves of a phylogenetic tree
"""
function findnonleaves(tree::Tree)
  nonleaves = Int64[]
  for i in 1:length(tree.nodes)
    if !isleaf(tree.nodes[i])
      push!(nonleaves, i)
    end
  end
  if length(nonleaves) == 0
    warn("No non-leaves detected")
  end
  return nonleaves
end


"""
Find the non-internal nodes of a phylogenetic tree
"""
function findnonnodes(tree::Tree)
  nonnodes = Int64[]
  for i in 1:length(tree.nodes)
    if !isnode(tree.nodes[i])
      push!(nonnodes, i)
    end
  end
  if length(nonnodes) == 0
    warn("No non-internal nodes detected")
  end
  return nonnodes
end


"""
Find the parent node of a specified node
"""
function parentnode(tree::Tree, node::Int64)
  if indegree(tree, node) == 1
    return tree.branches[tree.nodes[node].in[1]].source
  else
    error("In degree of specified node != 1")
  end
end


"""
Find the child nodes of a specified node
"""
function childnodes(tree::Tree, node::Int64)
  validnode(tree, node)
  nodes = Int64[]
  for i in tree.nodes[node].out
    push!(nodes, tree.branches[i].target)
  end
  return nodes
end


"""
Find all descendant nodes of a specified node
"""
function descendantnodes(tree::Tree, node::Int64)
  validnode(tree, node)
  nodecount = [0]
  nodelist = [node]
  while nodecount[end] < length(nodelist)
    push!(nodecount, length(nodelist))
    for i in nodelist[(nodecount[end-1]+1):nodecount[end]]
      append!(nodelist, childnodes(tree, i))
    end
  end
  return nodelist[2:end]
end


"""
Number of descendant nodes
"""
function descendantcount(tree::Tree, node::Int64)
  return length(descendantnodes(tree, node))
end


"""
Number of descendant nodes
"""
function descendantcount(tree::Tree, nodes::Array{Int64})
  count = fill(0, size(nodes))
  for i in eachindex(nodes)
    count[i] += descendantcount(tree, nodes[i])
  end
  return count
end


"""
Node pathway through which a specified node connects to a root
"""
function nodepath(tree::Tree, node::Int64)
  validnode(tree, node)
  path = [node]
  while isleaf(tree, path[end]) || isnode(tree, path[end])
    push!(path, parentnode(tree, path[end]))
  end
  return path
end


"""
Find all ancestral nodes of a specified node
"""
function ancestornodes(tree::Tree, node::Int64)
  return nodepath(tree, node)[2:end]
end


"""
Number of ancestral nodes
"""
function ancestorcount(tree::Tree, node::Int64)
  return length(ancestornodes(tree, node))
end


"""
Number of ancestral nodes
"""
function ancestorcount(tree::Tree, nodes::Array{Int64})
  count = fill(0, size(nodes))
  for i in eachindex(nodes)
    count[i] += ancestorcount(tree, nodes[i])
  end
  return count
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
  validnodes(tree, [node1; node2])
  path1 = reverse(nodepath(tree, node1))
  path2 = reverse(nodepath(tree, node2))
  if !areconnected(tree, node1, node2)
    error("Nodes are not connected")
  end
  minlength = minimum([length(path1), length(path2)])
  mrcnode_index = findlast(path1[1:minlength] .== path2[1:minlength])
  return [reverse(path1[(mrcnode_index+1):end]); path2[mrcnode_index:end]]
end


"""
Branch pathway through which a specified node connects to a root
"""
function branchpath(tree::Tree, node::Int64)
  path = []
  while isleaf(tree, node) || isnode(tree, node)
    push!(path, tree.nodes[node].in[1])
    node = tree.branches[path[end]].source
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
  minlength = minimum([length(path1), length(path2)])
  if minlength == 0
    mrcbranch_index = 0
  else
    mrcbranch_index = findlast(path1[1:minlength] .== path2[1:minlength])
  end
  return [reverse(path1[(mrcbranch_index+1):end]); path2[mrcbranch_index+1:end]]
end
