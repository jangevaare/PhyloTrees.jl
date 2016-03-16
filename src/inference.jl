"""
Calculates the log likelihood of a tree with observed sequences at leaves only
"""
function loglikelihood(tree::Tree, mod::Substitution_Model)
  vist_order = postorder(tree)
  seq_length = size(tree.nodes[1].seq, 2)
  nodes = find_nodes(tree)

  for i in nodes
    tree.nodes[i].seq = fill(1., (4, seq_length))
  end

  for i in visit_order[1:end-1]
    branch = tree.branches[tree.nodes[i].in_branches[1]]
    for j in 1:seq_length
      site_rate = tree.site_rates[j]
      tree.nodes[branch.source].seq[:,j] = tree.nodes[branch.source].seq[:,j] .* (P(mod, branch.length * branch.rate * site_rate) * tree.nodes[i].seq[:,j])
    end

  end
  root = visit_order[end]
  return sum(log(sum(tree.nodes[root].seq, 1)))
end
