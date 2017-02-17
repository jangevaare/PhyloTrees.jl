"""
postorder(tree::Tree)

`Node` postorder traversal order
"""
function postorder(tree::Tree)
  nodes = collect(keys(tree.nodes))
  visited = Dict{Int64, Bool}(i => false for i in nodes)
  visit_order = Int64[]
  next = nodes[findfirst(!collect(values(visited)))]
  while !all(collect(values(visited)))
    sub_visited = Bool[]
    for i in tree.nodes[next].out
      push!(sub_visited, visited[tree.branches[i].target])
    end
    if all(sub_visited) || length(sub_visited) == 0
      push!(visit_order, next)
      visited[next] = true
      if !all(collect(values(visited)))
        if length(tree.nodes[next].in) == 1
          next = tree.branches[tree.nodes[next].in[1]].source
        else
          next = nodes[findfirst(!collect(values(visited)))]
        end
      end
    else
      next = tree.branches[tree.nodes[next].out[!sub_visited][1]].target
    end
  end
  return visit_order
end
