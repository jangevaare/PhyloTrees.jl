"""
Log likelihood for a pair of sequences being a certain distance apart, under a
specified substitution model
"""
function loglikelihood(seq1::Array{Bool, 2},
                       seq2::Array{Bool, 2},
                       distance::Float64,
                       mod::SubstitutionModel,
                       site_rates::Vector{Float64})
  if size(seq1) !== size(seq2)
    throw("Sequences must be of the same length")
  elseif size(seq1, 1) !== 4
    throw("First dimension of sequence arrays must be 4")
  end
  ll = 0.
  pmat = P(mod, distance)
  for i = 1:size(seq1, 2)
    ll += log(pmat[seq1[:, i], seq2[:, i]][1])
  end
  return ll
end


function loglikelihood(seq1::Array{Bool, 2},
                       seq2::Array{Bool, 2},
                       distance::Float64,
                       mod::SubstitutionModel)
  return loglikelihood(seq1,
                       seq2,
                       distance,
                       mod,
                       fill(1., length(seq1)))
end


"""
Calculates the log likelihood of a tree with sequences observed at all leaves
"""
function loglikelihood(seq::Array{Bool, 3},
                       tree::Tree,
                       mod::SubstitutionModel,
                       site_rates::Vector{Float64})
  seq_length = size(seq, 2)
  if length(site_rates) !== seq_length
    throw("Dimensions of sequence data and site rates do not match")
  end
  leaves = findleaves(tree)
  if length(leaves) !== size(seq, 3)
    throw("Number of leaves and number of observed sequences do not match")
  end
  visit_order = postorder(tree)
  ll_seq = fill(0., (4, seq_length, length(tree.nodes)))
  for i in visit_order
    if isleaf(tree.nodes[i])
      leafindex = findfirst(leaves .== i)
      ll_seq[:, :, i] += log(seq[:, :, leafindex] .+ 0)
    else
      branches = tree.nodes[i].out
      for j in branches
        branch_length = get(tree.branches[j].length)
        child_node = tree.branches[j].target
        for k in 1:seq_length
          ll_seq[:, k, i] += log(exp(ll_seq[:, k, child_node])' * P(mod, branch_length * site_rates[k]))[:]
        end
      end
    end
  end
  return sum(ll_seq[:, :, visit_order[end]])
end


function loglikelihood(seq::Array{Bool, 3},
                       tree::Tree,
                       mod::SubstitutionModel)
  return loglikelihood(seq,
                       tree,
                       mod,
                       fill(1., size(seq, 2)))
end
