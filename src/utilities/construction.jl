"""
Add a node
"""
function addnode!(tree::Tree)
  push!(tree.nodes, Node())
  return tree
end


"""
Add multiple nodes
"""
function addnodes!(tree::Tree, nodes::Int64)
  if nodes < 0
    throw("Invalid number of nodes specified")
  end
  for i = 1:nodes
    push!(tree.nodes, Node())
  end
  return tree
end


"""
Add a branch
"""
function addbranch!(tree::Tree,
                    source::Int64,
                    target::Int64,
                    branch_length::Nullable{Float64})
  # Error checking
  validnodes(tree, [source; target])
  if target == source
    throw("Branch must connect unique nodes")
  end
  if length(tree.nodes[target].in) == 1
    throw("The in degree of the target node is > 1")
  end

  # Add branch
  push!(tree.branches, Branch(source, target, branch_length))

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
                    target::Int64,
                    branch_length::Float64)
  return addbranch!(tree, source, target, Nullable(branch_length))
end


"""
Add a branch
"""
function addbranch!(tree::Tree,
                    source::Int64,
                    target::Int64)
  return addbranch!(tree, source, target, Nullable{Float64}())
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64,
                 branch_length::Nullable{Float64})
  validnode(tree, source)
  tree = addnode!(tree)
  return addbranch!(tree, source, length(tree.nodes), branch_length)
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64,
                 branch_length::Float64)
  return branch!(tree, source, Nullable(branch_length))
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64)
  return branch!(tree, source, Nullable{Float64}())
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
  subtree = Tree()
  branchcount = 0
  branchlist = Int64[]
  append!(branchlist, tree.nodes[node].out)
  while nodecount < length(nodelist)
    nodecount = length(nodelist)
    for i in branchlist[branchcount+1:end]
      push!(nodelist, tree.branches[i].target)
      new_source = findfirst(tree.branches[i].source .== nodelist)
      new_branch_length = tree.branches[i].length
      branch!(subtree, new_source, new_branch_length)
    end
    branchcount = length(subtree.branches)
    for i in nodelist[nodecount+1:end]
      append!(branchlist, tree.nodes[i].out)
    end
  end
  return subtree
end


"""
Copy a node
"""
function copy(node::Node)
  return Node(copy(node.in), copy(node.out))
end


"""
Copy a branch
"""
function copy(branch::Branch)
  return Branch(copy(branch.target), copy(branch.source), copy(branch.length))
end


"""
Copy a tree
"""
function copy(tree::Tree)
  return Tree(map(copy, tree.nodes), map(copy, tree.branches))
end


"""
Change the source node of a branch
"""
function changesource!(tree::Tree,
                       branch::Int64,
                       newsource::Int64,
                       newlength::Nullable{Float64})
  validnode(tree, newsource)
  validbranch(tree, branch)
  oldsource = tree.branches[branch].source
  splice!(tree.nodes[oldsource].out, findfirst(tree.nodes[oldsource].out .== branch))
  tree.branches[branch].source = newsource
  tree.branches[branch].length = newlength
  push!(tree.nodes[newsource].out, branch)
  return tree
end


"""
Change the source node of a branch
"""
function changesource!(tree::Tree,
                       branch::Int64,
                       newsource::Int64,
                       newlength::Float64)
  return changesource!(tree, branch, newsource, Nullable(newlength))
end


"""
Change the source node of a branch
"""
function changesource!(tree::Tree,
                       branch::Int64,
                       newsource::Int64)
  return changesource!(tree, branch, newsource, Nullable{Float64}())
end


"""
Change the target node of a branch
"""
function changetarget!(tree::Tree,
                       branch::Int64,
                       newtarget::Int64,
                       newlength::Nullable{Float64})
  validnode(tree, newtarget)
  validbranch(tree, branch)
  if length(tree.nodes[newtarget].in) != 0
    throw("New target node has an in degree > 1")
  end
  oldtarget = tree.branches[branch].target
  splice!(tree.nodes[oldtarget].in, findfirst(tree.nodes[oldtarget].in .== branch))
  push!(tree.nodes[newtarget].in, branch)
  tree.branches[branch].target = newtarget
  tree.branches[branch].length = newlength
  return tree
end


"""
Change the target node of a branch
"""
function changetarget!(tree::Tree,
                       branch::Int64,
                       newtarget::Int64,
                       newlength::Float64)
  return changetarget!(tree, branch, newtarget, Nullable(newlength))
end


"""
Change the target node of a branch
"""
function changetarget!(tree::Tree,
                       branch::Int64,
                       newtarget::Int64)
  return changetarget!(tree, branch, newtarget, Nullable{Float64}())
end
