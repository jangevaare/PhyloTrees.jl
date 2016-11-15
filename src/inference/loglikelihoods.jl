"""
Calculates the log likelihood of a tree with sequences observed at all leaves
"""
function loglikelihood(seq::Vector{Sequence},
                       tree::Tree,
                       mod::SubstitutionModel,
                       site_rates::Vector{Float64})
  seq_length = length(site_rates)
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
        @simd for k in 1:seq_length
          seq_array[:, k, i] = seq_array[:, k, i] .* (seq_array[:, k, child_node]' * P(mod, branch_length * site_rates[k]))[:]
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


function loglikelihood(seq::Vector{Sequence},
                       tree::Tree,
                       mod::SubstitutionModel)
  return loglikelihood(seq,
                       tree,
                       mod,
                       fill(1., size(seq[1].nucleotides, 2)))
end
