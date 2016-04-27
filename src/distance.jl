"""
Distance between two nodes on a phylogenetic tree
"""
function distance(tree::Tree, node1::Int64, node2::Int64)
  path = branchpath(tree, node1, node2)
  dist = 0.
  for i in path
    dist += tree.branches[i].length
  end
  return dist
end
