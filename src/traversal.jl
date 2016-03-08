"""
Function to visit nodes of phylogenetic tree with postorder traversal
"""
function postorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  while !all(visited)
    # TODO
  end
  return visit_order
end


"""
Function to visit nodes of phylogenetic tree with preorder traversal
"""
function preorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  while !all(visited)
    # TODO
  end
  return visit_order
end
