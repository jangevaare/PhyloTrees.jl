"""
Log likelihood for a pair of sequences being a certain distance apart, under a
specified substitution model
"""
function loglikelihood(seq1::Array{Bool, 2},
                       seq2::Array{Bool, 2},
                       distance::Float64,
                       mod::SubstitutionModel)
  if size(seq1) !== size(seq2)
    error("Sequences must be of the same length")
  end
  if size(seq1, 1) !== 4
    error("First dimension of sequence arrays must be 4")
  end
  ll = 0
  pmat = P(mod, distance)
  for i = 1:size(seq1, 2)
    ll += log(pmat[seq1[:, i], seq2[:, i]][1])
  end
  return ll
end


# """
# Calculates the log likelihood of a tree with sequences observed at all leaves
# """
# function loglikelihood(tree::Tree,
#                        mod::SubstitutionModel,
#                        seq::Array{Bool, 3},
#                        site_rates::Vector{Float64})
#   if length(site_rates) !== size(seq, 2)
#     error("Dimensions of sequence date and site rates do not match")
#   end
#   vist_order = postorder(tree)
#   seq_length = size(seq, 2)
#   ll_seq = fill(0. size(seq))
#   leaves = findleaves(tree)
#
#   # TODO
#   #
#   # for i in visit_order[1:end-1]
#   #   branch = tree.branches[tree.nodes[i].in[1]]
#   #   for j in 1:seq_length
#   #     site_rate = tree.site_rates[j]
#   #     tree.nodes[branch.source].seq[:,j] = tree.nodes[branch.source].seq[:,j] .* (tree.nodes[i].seq[:,j]' * P(mod, branch.length * branch.rate * site_rate))[:]
#   #   end
#   #
#   # end
#   # root = visit_order[end]
#   # return sum(log(sum(tree.nodes[root].seq, 1)))
# end
