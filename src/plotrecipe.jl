function treeplot(tree::Tree)
  nodequeue = findroots(tree)
  treesize = leafcount.(Ref(tree), nodequeue) .+ 1
  distances = distance(tree, nodequeue)
  countpct = treesize / sum(treesize)
  height = cumsum(countpct) .- (0.5 * countpct)
  queueposition = 1
  while(queueposition <= length(nodequeue))
    children = childnodes(tree, nodequeue[queueposition])
    if length(children) > 0
      append!(nodequeue, children)
      subtreesize = leafcount.(Ref(tree), children) .+ 1
      append!(distances, distance(tree, children))
      append!(countpct, subtreesize / sum(treesize))
      append!(height, (height[queueposition] - (countpct[queueposition] / 2)) .+ (cumsum(countpct[end-length(subtreesize)+1:end]) .- (0.5 * countpct[end-length(subtreesize)+1:end])))
    end
    queueposition += 1
  end
  processorder = Union{Nothing, Int64}[]
  append!(processorder, fill(nothing, length(tree.nodes)))
  for i = 1:length(nodequeue)
    processorder[nodequeue[i]] = i
  end
  tree_x = Vector{Float64}[]
  tree_y = Vector{Float64}[]
  xmax = Float64[]
  for i in nodequeue
    if !isroot(tree, i)
      push!(tree_x, distances[[processorder[i]; processorder[parentnode(tree, i)]; processorder[parentnode(tree, i)]]].+= tree.height)
      push!(tree_y, height[[processorder[i]; processorder[i]; processorder[parentnode(tree, i)]]])
      push!(xmax, distances[processorder[i]])
    end
  end
  xmin = tree.height
  xmax .+= tree.height
  return tree_x, tree_y, xmin, maximum(xmax)
 end


@recipe function plot(tree::Tree)
  tree_x, tree_y, xmin, xmax = treeplot(tree)
  yaxis := false
  grid := :x
  legend := false
  @series begin
    seriestype := :path
    linecolor --> :black
    # tree_x, tree_y
    [tree_x[i][1:3] for i = eachindex(tree_x)],
    [tree_y[i][1:3] for i = eachindex(tree_y)]
  end
  @series begin
    seriestype := :scatter
    [[tree_x[i][1] for i = eachindex(tree_x)]; tree_x[1][end]],
    [[tree_y[i][1] for i = eachindex(tree_y)]; tree_y[1][end]]
  end
end