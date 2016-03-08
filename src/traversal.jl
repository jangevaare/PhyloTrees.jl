"""
Function to visit nodes of phylogenetic tree with preorder traversal
"""
function postorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  i = tree.nodes[1]
  while !all(visited)
    for j in tree.branches[i.out_branches]
      visited[j.target]

    if all(visted[])


"""
Function to visit nodes of phylogenetic tree with postorder traversal
"""
function preorder(tree::Tree)
  visited = fill(false, length(tree.nodes))
  visit_order = Int64[]
  while !all(visited)
    # TODO
  end
end
