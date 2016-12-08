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


"""
Distance between a node and its root on a phylogenetic tree
"""
function distance(tree::Tree, node::Int64)
  path = branchpath(tree, node)
  dist = 0.
  for i in path
    dist += tree.branches[i].length
  end
  return dist
end


"""
Distance between a node and its root on a phylogenetic tree
"""
function distance(tree::Tree, nodes::Array{Int64})
  distances = fill(0., size(nodes))
  for i in eachindex(nodes)
    distances[i] = distance(tree, nodes[i])
  end
  return distances
end
