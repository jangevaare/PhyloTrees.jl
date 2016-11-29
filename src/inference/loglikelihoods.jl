"""
Calculates the log likelihood of a tree with sequences observed at all leaves
"""
function loglikelihood(seq::Vector{Sequence},
                       tree::Tree,
                       mod::SubstitutionModel)
  seq_length = length(seq[1])
  leaves = findleaves(tree)
  if length(leaves) !== length(seq)
    error("Number of leaves and number of observed sequences do not match")
  end
  visit_order = postorder(tree)
  seq_array = fill(1., (4, seq_length, length(tree.nodes)))
  leafindex = 0
  for i in visit_order
    if isleaf(tree.nodes[i])
      leafindex += 1
      seq_array[:, :, i] = seq_array[:, :, i] .* seq[leafindex].nucleotides
    else
      branches = tree.nodes[i].out
      for j in branches
        branch_length = get(tree.branches[j].length)
        child_node = tree.branches[j].target
        p = P(mod, branch_length)
        @simd for k in 1:seq_length
          seq_array[:, k, i] = seq_array[:, k, i] .* (seq_array[:, k, child_node]' * p)[:]
        end
      end
    end
  end
  ll = 0.
  @simd for i in 1:seq_length
    ll += log(sum(seq_array[:, i, visit_order[end]] .* mod.π))
  end
  return ll
end
