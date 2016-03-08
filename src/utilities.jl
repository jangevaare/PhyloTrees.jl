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
    return root[1]
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
