"""
indegree(tree::Tree,
         node::Int64)

Determine the in degree of a `Node`
"""
function indegree(tree::Tree,
                  node::Int64)
  if !haskey(tree.nodes, node)
    error("Node does not exist")
  end
  return length(tree.nodes[node].in)
end


"""
outdegree(tree::Tree,
          node::Int64)

Determine the out degree of a `Node`
"""
function outdegree(tree::Tree,
                   node::Int64)
  if !haskey(tree.nodes, node)
    error("Node does not exist")
  end
  return length(tree.nodes[node].out)
end


"""
isroot(tree::Tree,
       node::Int64)

Determine if a `Node` is a root `Node`
"""
function isroot(tree::Tree,
                node::Int64)
  if outdegree(tree, node) > 0 && indegree(tree, node) == 0
    return true
  else
    return false
  end
end


"""
isleaf(tree::Tree,
       node::Int64)

Determine if a `Node` is a leaf `Node`
"""
function isleaf(tree::Tree,
                node::Int64)
  if outdegree(tree, node) == 0 && indegree(tree, node) == 1
    return true
  else
    return false
  end
end


"""
isinternal(tree::Tree,
           node::Int64)

Determine if a `Node` is an internal `Node`
"""
function isinternal(tree::Tree,
                    node::Int64)
  if outdegree(tree, node) > 0 && indegree(tree, node) == 1
    return true
  else
    return false
  end
end


"""
nodetype(tree::Tree,
         node::Int64)

Determine if a `Node` is an internal, root, or leaf `Node`
"""
function nodetype(tree::Tree,
                  node::Int64)
  ins = indegree(tree, node)
  outs = outdegree(tree, node)
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
findroots(tree::Tree)

Find the root `Node`s of a `Tree`
"""
function findroots(tree::Tree)
  roots = Int64[]
  for i in keys(tree.nodes)
    if isroot(tree, i)
      push!(roots, i)
    end
  end
  if length(roots) == 0
    @warn "No roots detected"
  end
  return roots
end


"""
findleaves(tree::Tree)

Find the leaf `Node`s of a `Tree`
"""
function findleaves(tree::Tree)
  leaves = Int64[]
  for i in keys(tree.nodes)
    if isleaf(tree, i)
      push!(leaves, i)
    end
  end
  if length(leaves) == 0
    @warn "No leaves detected"
  end
  return leaves
end


"""
findinternals(tree::Tree)

Find the internal `Node`s of a `Tree`
"""
function findinternals(tree::Tree)
  nodes = Int64[]
  for i in keys(tree.nodes)
    if isinternal(tree, i)
      push!(nodes, i)
    end
  end
  if length(nodes) == 0
    @warn "No internal nodes detected"
  end
  return nodes
end


"""
findnonroots(tree::Tree)

Find the non-root `Node`s of a `Tree`
"""
function findnonroots(tree::Tree)
  nonroots = Int64[]
  for i in keys(tree.nodes)
    if !isroot(tree, i)
      push!(nonroots, i)
    end
  end
  if length(nonroots) == 0
    @warn "No non-roots detected"
  end
  return nonroots
end


"""
findnonleaves(tree::Tree)

Find the non-leaf `Node`s of a `Tree`
"""
function findnonleaves(tree::Tree)
  nonleaves = Int64[]
  for i in 1:keys(tree.nodes)
    if !isleaf(tree, i)
      push!(nonleaves, i)
    end
  end
  if length(nonleaves) == 0
    @warn "No non-leaves detected"
  end
  return nonleaves
end


"""
findexternals(tree::Tree)

Find the external `Node`s of a `Tree`
"""
function findexternals(tree::Tree)
  externals = Int64[]
  for i in keys(tree.nodes)
    if !isinternal(tree, i)
      push!(externals, i)
    end
  end
  if length(externals) == 0
    @warn "No external nodes detected"
  end
  return externals
end


"""
parentnode(tree::Tree,
           node::Int64)

Find parent `Node`
"""
function parentnode(tree::Tree,
                    node::Int64)
  if indegree(tree, node) == 1
    return tree.branches[tree.nodes[node].in[1]].source
  else
    error("In degree of specified node != 1")
  end
end


"""
childnodes(tree::Tree,
           node::Int64)

Find child `Node`s
"""
function childnodes(tree::Tree,
                    node::Int64)
  if !haskey(tree.nodes, node)
    error("Node does not exist")
  end
  nodes = Int64[]
  for i in tree.nodes[node].out
    push!(nodes, tree.branches[i].target)
  end
  return nodes
end


"""
descendantnodes(tree::Tree,
                node::Int64)

Find descendant `Node`s
"""
function descendantnodes(tree::Tree,
                         node::Int64)
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
leafnodes(tree::Tree,
          node::Int64)

Find descendant `Node`s which are leaves
"""
function leafnodes(tree::Tree,
                   node::Int64)
  x = descendantnodes(tree, node)
  return x[isleaf.(Ref(tree), x)]
end


"""
leafcount(tree::Tree,
          node::Int64)

Count the descendant `Node`s which are leaves
"""
function leafcount(tree::Tree,
                   node::Int64)
  return length(leafnodes(tree, node))
end


"""
descendantcount(tree::Tree,
                node::Int64)

Find the number of descendant `Nodes`
"""
function descendantcount(tree::Tree,
                         node::Int64)
  return length(descendantnodes(tree, node))
end


"""
nodepath(tree::Tree,
         node::Int64)

`Node` pathway through which a specified `Node` connects to a root
"""
function nodepath(tree::Tree,
                  node::Int64)
  path = [node]
  while isleaf(tree, path[end]) || isinternal(tree, path[end])
    push!(path, parentnode(tree, path[end]))
  end
  return path
end


"""
ancestornodes(tree::Tree,
              node::Int64)

Find ancestral `Node`s
"""
function ancestornodes(tree::Tree,
                       node::Int64)
  return nodepath(tree, node)[2:end]
end


"""
ancestorcount(tree::Tree,
              node::Int64)

Number of ancestral `Node`s
"""
function ancestorcount(tree::Tree,
                       node::Int64)
  return length(ancestornodes(tree, node))
end


"""
noderoot(tree::Tree,
         node::Int64)

The root associated with a specified `Node`
"""
function noderoot(tree::Tree,
                  node::Int64)
  return nodepath(tree, node)[end]
end


"""
areconnected(tree::Tree,
             node1::Int64,
             node2::Int64)

Check for connectedness of two `Node`s
"""
function areconnected(tree::Tree,
                      node1::Int64,
                      node2::Int64)
  return noderoot(tree, node1) == noderoot(tree, node2)
end


"""
nodepath(tree::Tree,
         node1::Int64,
         node2::Int64)

`Node` pathway through which two specified `Node`s connect
"""
function nodepath(tree::Tree,
                  node1::Int64,
                  node2::Int64)
  if !areconnected(tree, node1, node2)
    error("Nodes are not connected")
  end
  path1 = reverse(nodepath(tree, node1))
  path2 = reverse(nodepath(tree, node2))
  minlength = minimum([length(path1), length(path2)])
  mrcnode_index = findlast(path1[1:minlength] .== path2[1:minlength])
  return [reverse(path1[(mrcnode_index+1):end]); path2[mrcnode_index:end]]
end


"""
branchpath(tree::Tree,
           node::Int64)

Branch pathway through which a specified node connects to a root
"""
function branchpath(tree::Tree,
                    node::Int64)
  path = Int64[]
  while isleaf(tree, node) || isinternal(tree, node)
    push!(path, tree.nodes[node].in[1])
    node = tree.branches[path[end]].source
  end
  return path
end


"""
branchpath(tree::Tree,
           node1::Int64,
           node2::Int64)

Branch pathway through which two specified nodes connect
"""
function branchpath(tree::Tree,
                    node1::Int64,
                    node2::Int64)
  if !areconnected(tree, node1, node2)
    error("Nodes are not connected")
  end
  path1 = reverse(branchpath(tree, node1))
  path2 = reverse(branchpath(tree, node2))
  minlength = minimum([length(path1), length(path2)])
  if minlength == 0
    mrcbranch_index = 0
  else
      branch_match = path1[1:minlength] .== path2[1:minlength]
      if any(branch_match)
          mrcbranch_index = findlast(branch_match)
      else
          mrcbranch_index = 0
      end
  end
  return [reverse(path1[(mrcbranch_index+1):end]); path2[mrcbranch_index+1:end]]
end
