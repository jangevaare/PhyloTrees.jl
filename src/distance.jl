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
  result = zeros(length(leaves), length(leaves))
  isempty(leaves) && return result
  index = DistanceIndex(tree)
  for j in eachindex(leaves), i in 1:j-1
    result[i, j] = result[j, i] = distance(index, leaves[i], leaves[j])
  end
  return result
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

"""
    DistanceIndex(tree)

Snapshot a tree or forest for repeated distance queries. Construction takes
O(n log n) time and space; each query takes O(log n) time. Rebuild the index
after changing topology or branch lengths. An index is independent of later
mutations to the original tree and may be shared by readers.
"""
struct DistanceIndex
  nodes::Dict{Int64, Int}
  ancestors::Matrix{Int}
  lengths::Matrix{Float64}
  depth::Vector{Int}
  roots::Vector{Int}
end

function DistanceIndex(tree::Tree)
  ids = collect(keys(tree.nodes))
  n = length(ids)
  nodes = Dict(id => i for (i, id) in enumerate(ids))
  levels = 1
  while (n >> levels) > 0
    levels += 1
  end
  ancestors = zeros(Int, n, levels)
  lengths = zeros(n, levels)
  depth = zeros(Int, n)
  roots = zeros(Int, n)
  for id in Iterators.reverse(postorder(tree))
    i = nodes[id]
    incoming = tree.nodes[id].in
    if isempty(incoming)
      ancestors[i, 1] = i
      roots[i] = i
    else
      length(incoming) == 1 || throw(ArgumentError("Nodes must have at most one parent"))
      branch = tree.branches[incoming[1]]
      parent = nodes[branch.source]
      ancestors[i, 1] = parent
      lengths[i, 1] = branch.length
      depth[i] = depth[parent] + 1
      roots[i] = roots[parent]
    end
  end
  for level in 2:levels, i in 1:n
    parent = ancestors[i, level-1]
    ancestors[i, level] = ancestors[parent, level-1]
    lengths[i, level] = lengths[i, level-1] + lengths[parent, level-1]
  end
  return DistanceIndex(nodes, ancestors, lengths, depth, roots)
end

"""
    distance(index::DistanceIndex, node1, node2)
    distance(index::DistanceIndex, node)

Query distances in the snapshot. The single-node form measures distance to its
root. Nodes in different components have no distance and cause an error.
"""
function distance(index::DistanceIndex, node1::Int64, node2::Int64)
  a, b = index.nodes[node1], index.nodes[node2]
  index.roots[a] == index.roots[b] || error("Nodes are not connected")
  return _indexed_distance(index, a, b)
end

function _indexed_distance(index::DistanceIndex, a::Int, b::Int)
  if index.depth[a] < index.depth[b]
    a, b = b, a
  end
  total = 0.0
  difference = index.depth[a] - index.depth[b]
  for level in 1:size(index.ancestors, 2)
    if ((difference >> (level-1)) & 1) == 1
      total += index.lengths[a, level]
      a = index.ancestors[a, level]
    end
  end
  a == b && return total
  for level in size(index.ancestors, 2):-1:1
    if index.ancestors[a, level] != index.ancestors[b, level]
      total += index.lengths[a, level] + index.lengths[b, level]
      a, b = index.ancestors[a, level], index.ancestors[b, level]
    end
  end
  # Sum lengths along the path rather than subtracting root distances. This
  # avoids cancellation for short paths below a very long shared branch.
  return total + index.lengths[a, 1] + index.lengths[b, 1]
end

function distance(index::DistanceIndex, node::Int64)
  a = index.nodes[node]
  return _indexed_distance(index, a, index.roots[a])
end
