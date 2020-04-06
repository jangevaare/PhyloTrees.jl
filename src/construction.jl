const changeheight!(tree, height) = setheight!(tree, height)
const changetarget!(tree, branch, new_target) = settarget!(tree, branch, new_target)
const changesource!(tree, branch, new_source) = setsource!(tree, branch, new_source)
const changelength!(tree, branch, new_length) = setlength!(tree, branch, new_length)

"""
setheight!(tree::Tree,
           height::Float64)

Sets the height of a `Tree`
"""
function setheight!(tree::Tree,
                    height::Float64)
    tree.height = height
    return tree
end

"""
addnode!(tree::Tree)

Adds a single `Node` to a `Tree`
"""
function addnode!(tree::Tree)
  # Find highest node index
  if length(tree.nodes) == 0
    max_node = 0
  else
    max_node = maximum(keys(tree.nodes))
  end
  # Add the new node
  tree.nodes[max_node+1] = Node()
  # Return the updated tree
  return tree
end


"""
addnodes!(tree::Tree,
          nodes::Int64)

Adds multiple `Node`s to a `Tree`
"""
function addnodes!(tree::Tree,
                   nodes::Int64)
  # Find highest node index
  if length(tree.nodes) == 0
    max_node = 0
  else
    max_node = maximum(keys(tree.nodes))
  end
  # Add the new nodes
  for i = 1:nodes
    tree.nodes[max_node+i] = Node()
  end
  # Return the updated tree
  return tree
end


"""
deletenode!(tree::Tree,
            nodes::Int64)

Deletes a specified `Node` from a `Tree`
"""
function deletenode!(tree::Tree,
                     node::Int64)
  # Check if node exists
  if !haskey(tree.nodes, node)
    error("Node does not exist")
  # Check if any branches are connected to node
  elseif length(tree.nodes[node].in) > 0 || length(tree.nodes[node].out) > 0
    error("There are currently branches connected to this node")
  end
  # Remove node itself
  delete!(tree.nodes, node)
  return tree
end


"""
addbranch!(tree::Tree,
           source::Int64,
           target::Int64,
           branch_length::Float64)

Adds a `Branch` of specified length to a `Tree`
"""
function addbranch!(tree::Tree,
                    source::Int64,
                    target::Int64,
                    branch_length::Float64)
  # Error checking
  if target == source
    error("Branch must connect unique nodes")
  elseif !haskey(tree.nodes, source)
    error("Source node does not exist")
  elseif !haskey(tree.nodes, target)
    error("Target node does not exist")
  elseif length(tree.nodes[target].in) == 1
    error("The in degree of the target node is > 1")
  end
  # Find highest branch index
  if length(tree.branches) == 0
    max_branch = 0
  else
    max_branch = maximum(keys(tree.branches))
  end
  # Add the new branch
  tree.branches[max_branch+1] = Branch(source, target, branch_length)
  # Update the associated source and target nodes
  push!(tree.nodes[source].out, max_branch+1)
  push!(tree.nodes[target].in, max_branch+1)
  # Return updated tree
  return tree
end


"""
branch!(tree::Tree,
        source::Int64,
        branch_length::Float64)

Adds a `Branch` of a specified length, and a `Node` to a `Tree`
"""
function branch!(tree::Tree,
                 source::Int64,
                 branch_length::Float64)
  # Error checking
  if !haskey(tree.nodes, source)
    error("Source node does not exist")
  end
  # Find highest node index
  if length(tree.nodes) == 0
    max_node = 0
  else
    max_node = maximum(keys(tree.nodes))
  end
  # Add the new node
  tree.nodes[max_node+1] = Node()
  # Find highest branch index
  if length(tree.branches) == 0
    max_branch = 0
  else
    max_branch = maximum(keys(tree.branches))
  end  # Add the new branch
  tree.branches[max_branch+1] = Branch(source, max_node+1, branch_length)
  # Update the associated source and target nodes
  push!(tree.nodes[source].out, max_branch+1)
  push!(tree.nodes[max_node+1].in, max_branch+1)
  # Return updated tree
  return tree
end


"""
setsource!(tree::Tree,
              branch::Int64,
              new_source::Int64)

Set the source `Node` of a `Branch`
"""
function setsource!(tree::Tree,
                    branch::Int64,
                    new_source::Int64)
  # Error checking
  if !haskey(tree.branches, branch)
    error("Branch does not exist")
  elseif !haskey(tree.nodes, newsource)
    error("New source node does not exist")
  elseif new_source == tree.branches[branch].target
    error("Branch must connect unique nodes")
  end
  # Identify old source node
  old_source = tree.branches[branch].source
  # Remove branch reference from old source node
  splice!(tree.nodes[old_source].out, findfirst(tree.nodes[old_source].out .== branch))
  # Update new source node with branch reference
  push!(tree.nodes[newsource].out, branch)
  # Update branch with new source node reference
  tree.branches[branch].source = new_source
  # Return updated tree
  return tree
end


"""
settarget!(tree::Tree,
              branch::Int64,
              new_target::Int64)

Set the source `Node` of a `Branch`
"""
function settarget!(tree::Tree,
                    branch::Int64,
                    new_target::Int64)
  if !haskey(tree.branches, branch)
    error("Branch does not exist")
  elseif !haskey(tree.nodes, new_target)
    error("New target node does not exist")
  elseif length(tree.nodes[new_target].in) != 0
    error("New target node has an in degree > 1")
  end
  # Identify old target node
  old_target = tree.branches[branch].target
  # Remove branch reference from old target node
  splice!(tree.nodes[old_target].in, findfirst(tree.nodes[old_target].in .== branch))
  # Add branch reference to new target node
  push!(tree.nodes[new_target].in, branch)
  # Update branch with new target node reference
  tree.branches[branch].target = new_target
  # Return updated tree
  return tree
end


"""
setlength!(tree::Tree,
              branch::Int64,
              new_length::Float64)

Set the length of a `Branch`
"""
function setlength!(tree::Tree,
                    branch::Int64,
                    new_length::Float64)
    if !haskey(tree.branches, branch)
        error("Branch does not exist")
    elseif new_length < 0.0
        error("New branch length is < 0.0")
    end
    tree.branches[branch].length = new_length
end


"""
deletebranch!(tree::Tree,
              branch::Int64)

Delete a `Branch` from a `Tree`
"""
function deletebranch!(tree::Tree,
                       branch::Int64)
  if !haskey(tree.branches, branch)
    error("Branch does not exist")
  end
  # Identify old source node
  old_source = tree.branches[branch].source
  # Identify old target node
  old_target = tree.branches[branch].target
  # Remove branch reference from its source node
  splice!(tree.nodes[old_source].out, findfirst(tree.nodes[old_source].out .== branch))
  # Remove branch reference from its target node
  splice!(tree.nodes[old_target].in, findfirst(tree.nodes[old_target].in .== branch))
  # Remove branch itself
  delete!(tree.branches, branch)
  # Return the updated tree
  return tree
end
