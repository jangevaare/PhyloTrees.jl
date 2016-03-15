"""
Simulate sequences at all nodes in a phylogenetic tree following a specified
substitution model
"""
function simulate!(tree::Tree, mod::Substitution_Model)
  visit_order = reverse(postorder(tree))
  seq_length = size(tree.nodes[visit_order[1]].seq, 2)
  tree.nodes[visit_order[1]].seq = rand(Multinomial(1, mod.π), seq_length)

  for i in visit_order[2:end]
    source = tree.branches[tree.nodes[i].in_branches[1]].source
    branch_length = tree.branches[tree.nodes[i].in_branches[1]].length
    branch_rate = tree.branches[tree.nodes[i].in_branches[1]].rate
    for j in 1:seq_length
      site_rate = tree.site_rates[j]
      p = P(mod, branch_length * branch_rate * site_rate)
      tree.nodes[i].seq[:,j] = rand(Multinomial(1, p * tree.nodes[source].seq[:,j]))
    end
  end
  return tree
end
