"""
Node of phylogenetic tree
"""
type Node
  in::Vector{Int64}
  out::Vector{Int64}

  Node() = new(Int64[], Int64[])
end


"""
Directed branch connecting two nodes of phylogenetic tree
"""
type Branch
  source::Int64
  target::Int64
  length::Nullable{Float64}

  function Branch(source::Int64, target::Int64, length::Float64)
    if length < 0
      error("Branch length must be positive")
    end
    return new(source, target, Nullable(length))
  end

  function Branch(source::Int64, target::Int64, length::Nullable{Float64})
    return new(source, target, length)
  end

  function Branch(source::Int64, target::Int64)
    return new(source, target, Nullable{Float64}())
  end

end


"""
Phylogenetic tree object
"""
type Tree
  nodes::Vector{Node}
  branches::Vector{Branch}

  Tree() = new([Node()], Branch[])

  Tree(nodes::Vector{Node}, branches::Vector{Branch}) = new(nodes, branches)

  function Tree(nodes::Int64)
    if nodes < 0
      error("Invalid number of nodes specified")
    end
    tree = new(Node[], Branch[])
    for i = 1:nodes
      push!(tree.nodes, Node())
    end
    return tree
  end

end


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
    error("Invalid number of nodes specified")
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
                    branch_length::Float64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  validnode(tree, [source; target])
  if target == source
    error("Branch must connect unique nodes")
  end
  if length(tree.nodes[target].in) == 1
    error("The in degree of the target node is > 1")
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
                    branch_length::Nullable{Float64})
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  validnode(tree, [source; target])
  if target == source
    error("Branch must connect unique nodes")
  end
  if length(tree.nodes[target].in) == 1
    error("The in degree of the target node is > 1")
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
                    target::Int64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  validnode(tree, [source; target])
  if target == source
    error("Branch must connect unique nodes")
  end
  if length(tree.nodes[target].in) == 1
    error("The in degree of the target node is > 1")
  end

  # Add branch
  push!(tree.branches, Branch(source, target))

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
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  validnode(tree, source)

  # Add node
  push!(tree.nodes, Node())

  # Add branch
  push!(tree.branches, Branch(source, node_count+1, branch_length))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out, length(tree.branches))
  push!(tree.nodes[node_count+1].in, length(tree.branches))

  # Return updated tree
  return tree
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64,
                 branch_length::Nullable{Float64})
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  validnode(tree, source)

  # Add node
  push!(tree.nodes, Node())

  # Add branch
  push!(tree.branches, Branch(source, node_count+1, branch_length))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out, length(tree.branches))
  push!(tree.nodes[node_count+1].in, length(tree.branches))

  # Return updated tree
  return tree
end


"""
Add a branch and a node
"""
function branch!(tree::Tree,
                 source::Int64)
  node_count = length(tree.nodes)
  branch_count = length(tree.branches)

  # Error checking
  validnode(tree, source)

  # Add node
  push!(tree.nodes, Node())

  # Add branch
  push!(tree.branches, Branch(source, node_count+1))

  # Update the associated source and target nodes
  push!(tree.nodes[source].out, length(tree.branches))
  push!(tree.nodes[node_count+1].in, length(tree.branches))

  # Return updated tree
  return tree
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
