"""
distance(tree::Tree,
         node1::Int64,
         node2::Int64)

Distance between two `Node`s on a `Tree`
"""
function distance(tree::Tree,
                  node1::Int64,
                  node2::Int64)
  path = branchpath(tree, node1, node2)
  dist = 0.
  for i in path
    dist += tree.branches[i].length
  end
  return dist
end


"""
distance(tree::Tree)

Pairwise distances between all leaf `Node`s on a `Tree`
"""
function distance(tree::Tree)
  leaves = findleaves(tree)
  return [distance(tree, i, j) for i in leaves, j in leaves]
end


"""
distance(tree::Tree,
         node::Int64)

Distance between a `Node` and it's associated root
"""
function distance(tree::Tree,
                  node::Int64)
  path = branchpath(tree, node)
  dist = 0.
  for i in path
    dist += tree.branches[i].length
  end
  return dist
end