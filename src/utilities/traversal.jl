"""
Function to visit the nodes of a phylogenetic tree with postorder traversal
"""
function postorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  next = findfirst(!visited)
  while !all(visited)
    sub_visited = Bool[]
    for i in tree.nodes[next].out
      push!(sub_visited, visited[tree.branches[i].target])
    end
    if all(sub_visited) || length(sub_visited) == 0
      push!(visit_order, next)
      visited[next] = true
      if !all(visited)
        if length(tree.branches[tree.nodes[next].in]) > 0
          next = tree.branches[tree.nodes[next].in[1]].source
        else
          next = findfirst(!visited)
        end
      end
    else
      next = tree.branches[tree.nodes[next].out[!sub_visited][1]].target
    end
  end
  return visit_order
end
