import Plots.plot


"""
Produce a `Tree` plot
"""
function plot(tree::Tree)
  nodequeue = findroots(tree)
  treesize = descendantcount(tree, nodequeue) + 1
  distances = distance(tree, nodequeue)
  countpct = treesize / sum(treesize)
  height = cumsum(countpct) .- (0.5 * countpct)
  queueposition = 1
  while(queueposition <= length(nodequeue))
    children = childnodes(tree, nodequeue[queueposition])
    if length(children) > 0
      append!(nodequeue, children)
      subtreesize = descendantcount(tree, children) + 1
      append!(distances, distance(tree, children))
      append!(countpct, subtreesize / sum(treesize))
      append!(height, (height[queueposition] - (countpct[queueposition] / 2)) + (cumsum(countpct[end-length(subtreesize)+1:end]) .- (0.5 * countpct[end-length(subtreesize)+1:end])))
    end
    queueposition += 1
  end
  processorder = fill(Nullable{Int64}(), length(tree.nodes))
  for i = 1:length(nodequeue)
    processorder[nodequeue[i]] = i
  end
  tree_x = Float64[]
  tree_y = Float64[]
  tree_line = Int64[]
  for i in nodequeue
    if !isroot(tree, i)
      append!(tree_x, distances[[get(processorder[i]), get(processorder[parentnode(tree, i)]), get(processorder[parentnode(tree, i)])]])
      append!(tree_y, height[[get(processorder[i]), get(processorder[i]), get(processorder[parentnode(tree, i)])]])
      append!(tree_line, fill(i, 3))
    end
  end
  return plot(tree_x, tree_y, line = (1, 1, :path), group=tree_line, color=:black, key=false, yticks=nothing, xlim = (-1., maximum(tree_x)+1))
end
