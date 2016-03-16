
"""
The first encountered root of a phylogenetic tree
"""
function find_root(tree::Tree)
  root = Int64[]
  for i in tree.nodes
    if length(i.in_branches) == 0
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
    if length(i.out_branches) == 0
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
    if length(i.out_branches) > 0
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
Convert node reference id to a node tree index
"""
function node_index(tree, id::Int64)
  # TODO
end


"""
Convert branch reference id to a branch tree index
"""
function branch_index(tree, id::Int64)
  # TODO
end


"""
Convert node tree index to a node reference id
"""
function node_id(tree, index::Int64)
  # TODO
end


"""
Convert branch tree index to a branch reference id
"""
function branch_id(tree, index::Int64)
  # TODO
end
