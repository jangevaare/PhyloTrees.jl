"""
validnodes(tree::Tree, node:Int64)

Determine if node index is valid
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
validnodes(tree::Tree, nodes::Array{Int64})

Determine if node indices are valid
"""
function validnodes(tree::Tree,
                    nodes::Array{Int64})
  [validnode(tree, i) for i in nodes]
end


"""
validnodes(tree::Tree, nodes::UnitRange{Int64})

Determine if node indices are valid
"""
function validnodes(tree::Tree,
                    nodes::UnitRange{Int64})
  [validnode(tree, i) for i in nodes]
end


"""
validbranch(tree::Tree, branch::Int64)

Determine if a branch index is valid
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
validbranches(tree::Tree, branches::Array{Int64})

Determine if branch indices are valid
"""
function validbranches(tree::Tree,
                       branches::Array{Int64})
  [validbranch(tree, i) for i in branches]
end


"""
validbranches(tree::Tree, branches::UnitRange{Int64})

Determine if branch indices are valid
"""
function validbranches(tree::Tree,
                       branches::UnitRange{Int64})
  [validbranch(tree, i) for i in branches]
end


"""
indegree(node::Node)

Determine the in degree of a node
"""
function indegree(node::Node)
  return length(node.in)
end


"""
indegree(tree::Tree, node::Int64)

Determine the in degree of a node
"""
function indegree(tree::Tree,
                  node::Int64)
  validnode(tree, node)
  return indegree(tree.nodes[node])
end


"""
outdegree(node::Node)

Determine the out degree of a node
"""
function outdegree(node::Node)
  return length(node.out)
end


"""
outdegree(tree::Tree, node::Int64)

Determine the out degree of a node
"""
function outdegree(tree::Tree,
                   node::Int64)
  validnode(tree, node)
  return outdegree(tree.nodes[node])
end


"""
isroot(node::Node)

Determine if a node is a root node
"""
function isroot(node::Node)
  if outdegree(node) > 0 && indegree(node) == 0
    return true
  else
    return false
  end
end


"""
isroot(tree::Tree, node::Int64)

Determine if a node is a root node
"""
function isroot(tree::Tree,
                node::Int64)
  validnode(tree, node)
  return isroot(tree.nodes[node])
end


"""
isleaf(node::Node)

Determine if a node is a leaf node
"""
function isleaf(node::Node)
  if outdegree(node) == 0 && indegree(node) == 1
    return true
  else
    return false
  end
end


"""
isleaf(tree::Tree, node::Int64)

Determine if a node is a leaf node
"""
function isleaf(tree::Tree,
                node::Int64)
  validnode(tree, node)
  return isleaf(tree.nodes[node])
end


"""
isnode(node::Node)

Determine if a node is an internal node
"""
function isnode(node::Node)
  if outdegree(node) > 0 && indegree(node) == 1
    return true
  else
    return false
  end
end


"""
isnode(tree::Tree, node::Int64)

Determine if a node is an internal node
"""
function isnode(tree::Tree,
                node::Int64)
  validnode(tree, node)
  return isnode(tree.nodes[node])
end


"""
nodetype(node::Node)

Determine if a node is an internal node, root node or leaf node
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
nodetype(tree::Tree, node::Int64)

Determine if a node is an internal node, root node or leaf node
"""
function nodetype(tree::Tree,
                  node::Int64)
  if validnode(tree, node)
    return nodetype(tree.nodes[node])
  end
end


"""
findroots(tree::Tree)

Find the roots of a `Tree`
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
findroot(tree::Tree)

Find the root of a `Tree`
"""
function findroot(tree::Tree)
  roots = findroots(tree)
  if length(roots) != 1
    error("More than 1 root detected")
  else
    return roots[1]
  end
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
  path = Int64[]
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


"""
Add a node
"""
function addnode!(tree::Tree)
  push!(tree.nodes, Node{typeof(tree).parameters[1]}())
  return tree
end


"""
Add a node
"""
function addnode!(tree::Tree, label::String)
  push!(tree.nodes, Node{typeof(tree).parameters[1]}(label))
  return tree
end


"""
Add multiple nodes
"""
function addnodes!(tree::Tree, nodes::Int64)
  if nodes < 0
    error("Invalid number of nodes specified")
  end
  for i = 1:nodes
    addnode!(tree)
  end
  return tree
end


"""
Add a branch
"""
function addbranch!(tree::Tree,
                    source::Int64,
                    target::Int64,
                    branch_length::Float64)
  # Error checking
  validnodes(tree, [source; target])
  if target == source
    error("Branch must connect unique nodes")
  end
  if length(tree.nodes[target].in) == 1
    error("The in degree of the target node is > 1")
  end

  # Add branch
  push!(tree.branches, Branch{typeof(tree).parameters[2]}(source, target, branch_length))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out, length(tree.branches))
  push!(tree.nodes[target].in, length(tree.branches))

  # Return updated tree
  return tree
end


"""
Add a branch
"""
function addbranch!(tree::Tree,
                    source::Int64,
                    target::Int64)
  # Error checking
  validnodes(tree, [source; target])
  if target == source
    error("Branch must connect unique nodes")
  end
  if length(tree.nodes[target].in) == 1
    error("The in degree of the target node is > 1")
  end

  # Add branch
  push!(tree.branches, Branch{typeof(tree).parameters[2]}(source, target))

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
  validnode(tree, source)
  tree = addnode!(tree)
  return addbranch!(tree, source, length(tree.nodes), branch_length)
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64)
  validnode(tree, source)
  tree = addnode!(tree)
  return addbranch!(tree, source, length(tree.nodes))
end


"""
Add a subtree to a phylogenetic tree
"""
function addsubtree!(tree::Tree,
                     newsubtree::Tree)
  temptree = subtree(newsubtree, findroots(newsubtree)[1])
  branchcount = length(tree.branches)
  nodecount = length(tree.nodes)
  for i in temptree.nodes
    i.in += branchcount
    i.out += branchcount
  end
  for i in temptree.branches
    i.source += nodecount
    i.target += nodecount
  end
  append!(tree.nodes, temptree.nodes)
  append!(tree.branches, temptree.branches)
  return tree
end


"""
Extract a subtree at a particular node from a phylogenetic tree
"""
function subtree(tree::Tree,
                 node::Int64)
  # Error checking...
  validnode(tree, node)
  # Initialize objects for `while` loop to build subtree
  nodecount = 0
  nodelist = [node]
  subtree = Tree{typeof(tree).parameters[1], typeof(tree).parameters[2]}()
  addnode!(subtree)
  branchcount = 0
  branchlist = Int64[]
  append!(branchlist, tree.nodes[node].out)
  while nodecount < length(nodelist)
    nodecount = length(nodelist)
    for i in branchlist[branchcount+1:end]
      push!(nodelist, tree.branches[i].target)
      new_source = findfirst(tree.branches[i].source .== nodelist)
      branch!(subtree, new_source, tree.branches[i].length)
    end
    branchcount = length(subtree.branches)
    for i in nodelist[nodecount+1:end]
      append!(branchlist, tree.nodes[i].out)
    end
  end
  return subtree
end


"""
Change the source node of a branch
"""
function changesource!(tree::Tree,
                       branch::Int64,
                       newsource::Int64)
  validnode(tree, newsource)
  validbranch(tree, branch)
  oldsource = tree.branches[branch].source
  splice!(tree.nodes[oldsource].out, findfirst(tree.nodes[oldsource].out .== branch))
  tree.branches[branch].source = newsource
  push!(tree.nodes[newsource].out, branch)
  return tree
end


"""
Change the target node of a branch
"""
function changetarget!(tree::Tree,
                       branch::Int64,
                       newtarget::Int64)
  validnode(tree, newtarget)
  validbranch(tree, branch)
  if length(tree.nodes[newtarget].in) != 0
    error("New target node has an in degree > 1")
  end
  oldtarget = tree.branches[branch].target
  splice!(tree.nodes[oldtarget].in, findfirst(tree.nodes[oldtarget].in .== branch))
  push!(tree.nodes[newtarget].in, branch)
  tree.branches[branch].target = newtarget
  return tree
end


"""
setlabel!(node::Node, label::String)

Set the label of a node
"""
function setlabel!(node::Node, label::String)
  node.label = Nullable(label)
  return node
end


"""
haslabel(node::Node)

Determine if a node has a label
"""
function haslabel(node::Node)
  return !isnull(node.label)
end


"""
getlabel(node::Node)

Get the label of a node
"""
function getlabel(node::Node)
  if haslabel(node)
    return get(node.label)
  else
    error("Node does not have label")
  end
end


"""
setdata!(x::TreeComponent, data)

Set data of a `Node` or `Branch`
"""
function setdata!(x::TreeComponent, data)
  x.data = Nullable(data)
  return x
end


"""
hasdata(x::TreeComponent)

Determine if a `Node` or `Branch` has data
"""
function hasdata(x::TreeComponent)
  return !isnull(x.data)
end


"""
getdata(x::TreeComponent)

Get data of a `Node` or `Branch`
"""
function getdata(x::TreeComponent)
  if hasdata(x)
    return get(x.data)
  else
    error("Component does not have data")
  end
end
