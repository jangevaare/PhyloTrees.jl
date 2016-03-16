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


"""
Make observations from leaves of phylogenetic tree
"""
function observe(tree::Tree, nodes::Vector{Int64})
  obs = Array{Float64}[]
  for i in nodes
    if is_leaf(tree.nodes[i])
      error("Node $i is not a leaf, and can not be observed")
    end
    push!(obs, tree.nodes[i].seq)
  end
  return obs
end


observe(tree::Tree) = observe(tree, find_leaves(tree))
