function _treeplot(tree::Tree)
  nodequeue = findroots(tree)
  treesize = leafcount.(Ref(tree), nodequeue)
  distances = distance.(Ref(tree), nodequeue)
  countpct = treesize / sum(treesize)
  left_pos = cumsum(countpct) .- (0.5 * countpct)
  queueposition = 1
  while(queueposition <= length(nodequeue))
    @debug "Processing Node $(nodequeue[queueposition])"
    children = childnodes(tree, nodequeue[queueposition])
    @debug "Children Nodes = $children"
    if length(children) > 0
      append!(nodequeue, children)

      # find the proportion of all leaf nodes contained the subtrees
      subtreesize = max.(leafcount.(Ref(tree), children), 1)
      @debug "Number of leaves per child = $subtreesize"

      append!(countpct, subtreesize / sum(treesize))
      @debug "Proportion of total leaves per child = $(subtreesize / sum(treesize))"
      # calculate the positions
      # 1a - find parent node postion
      # 1b - find left-most leaf position of subtree
      subtree_left = left_pos[queueposition] - 0.5 * countpct[queueposition]
      @debug "Position of parent node = $(left_pos[queueposition])"
      @debug "Leftmost descendant leaf node position = $subtree_left"
      
      # 2a - find indices of children
      c_ind = (length(countpct) - length(children) + 1):length(countpct)
      @debug "Indices of children = $c_ind"
      # 2b - find position relative to left of subtree
      # 2c - use a cumulative sum based on leaf node count %
      # 2d - adjust these cumulative-sum-based positions down to their midpoints
      append!(left_pos, subtree_left .+ cumsum(countpct[c_ind]) .- 0.5 * countpct[c_ind])
      @debug "Position of children = $(left_pos[c_ind])"
    end
    queueposition += 1
    @debug "Increment queue position" NewPosition = queueposition
  end

  # distance from root + tree.height as node height/distance
  heights = distance.(Ref(tree), nodequeue) .+ tree.height

  tree_x = Vector{Float64}[]
  tree_y = Vector{Float64}[]
  leaf_indices = Int64[]
  node_ids = Int64[]

  for i in eachindex(nodequeue)
    if !isroot(tree, nodequeue[i])
      pn_index = findfirst(parentnode(tree, nodequeue[i]) .== nodequeue)
      push!(tree_x, heights[[i; pn_index; pn_index]])
      push!(tree_y, left_pos[[i; i; pn_index]])
      if isleaf(tree, nodequeue[i])
        push!(leaf_indices, length(tree_y))
      end
      push!(node_ids, nodequeue[i])
    end
  end
  return tree_x, tree_y, leaf_indices, node_ids
 end


@recipe function plot(tree::Tree; plot_leaves::Bool = true, hover_ids::Bool = false)
  tree_x, tree_y, leaf_indices, node_ids = _treeplot(tree)
  yaxis := false
  grid := :x
  legend := false
  @series begin
    seriestype := :path
    linecolor --> :black
    tree_x, tree_y
  end
  if plot_leaves
    @series begin
      seriestype := :scatter
      marker --> :diamond
      markersize --> 100 * length(leaf_indices)^-1
      if hover_ids
        hover := ["Node $x" for x in node_ids[leaf_indices]]
      end
      getindex.(tree_x[leaf_indices], 1),  getindex.(tree_y[leaf_indices], 1)
    end
  end
end