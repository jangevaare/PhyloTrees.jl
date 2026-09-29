"""
    postorder(tree::Tree)

Return node IDs with children before their parents. Supports forests, isolated
nodes, and arbitrary node IDs. Throws `ArgumentError` for a directed cycle.
"""
function postorder(tree::Tree)
  order = Int64[]
  sizehint!(order, length(tree.nodes))
  state = Dict{Int64, UInt8}()
  stack = Tuple{Int64, Bool}[]
  for start in keys(tree.nodes)
    get(state, start, 0x00) == 0x02 && continue
    push!(stack, (start, false))
    while !isempty(stack)
      node, expanded = pop!(stack)
      if expanded
        state[node] = 0x02
        push!(order, node)
      else
        status = get(state, node, 0x00)
        status == 0x02 && continue
        status == 0x01 && throw(ArgumentError("Tree contains a directed cycle"))
        state[node] = 0x01
        push!(stack, (node, true))
        for edge in Iterators.reverse(tree.nodes[node].out)
          push!(stack, (tree.branches[edge].target, false))
        end
      end
    end
  end
  return order
end
