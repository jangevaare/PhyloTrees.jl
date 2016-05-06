import Gadfly.plot

"""
Produce a data frame for the purposes of plotting a `Tree`
"""
function plot(tree::Tree, plotargs...)
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
  lines = DataFrame(line=Int64[], x=Float64[], y=Float64[])
  for i in nodequeue
    if !isroot(tree, i)
      append!(lines, DataFrame(line=[i, i, i], x=distances[[get(processorder[i]), get(processorder[parentnode(tree, i)]), get(processorder[parentnode(tree, i)])]], y=height[[get(processorder[i]), get(processorder[parentnode(tree, i)]), get(processorder[i])]]))
    else
      append!(lines, DataFrame(line=[i], x=distances[get(processorder[i])], y=height[get(processorder[i])]))
    end
  end
  # return lines
  return plot(lines, x="x", y="y", group="line", Geom.line, Guide.xlabel(nothing), Guide.ylabel(nothing), Guide.yticks(ticks=nothing), plotargs...)
end
