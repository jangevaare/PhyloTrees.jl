"""
Simulate sequences for all nodes in a phylogenetic tree following a specified
substitution model
"""
function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  root_seq::Sequence,
                  site_rates::Vector{Float64})
  # Error checking
  if root_seq.length != length(site_rates)
    error("Dimension of root sequence must match length of site rates")
  end

  # Initialize sequence array
  seq = fill(Nullable{Sequence}(), length(tree.nodes))
  visit_order = reverse(postorder(tree))

  # Set root sequence
  seq[visit_order[1]] = Nullable(root_seq)

  # Iterate through remaining nodes
  for i in visit_order[2:end]
    source = tree.branches[tree.nodes[i].in[1]].source
    branch_length = get(tree.branches[tree.nodes[i].in[1]].length)
    seq[i] = seq[source]
    for j in 1:seq[i].value.length
      site_rate = site_rates[j]
      p = P(mod, branch_length * site_rate)
      seq[i].value.nucleotides[:,j] = rand(Multinomial(1, (seq[source].value.nucleotides[:,j]' * p)[:]))
    end
  end
  return seq
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  root_seq::Sequence)
  return simulate(tree,
                  mod,
                  root_seq,
                  fill(1., root_seq.length))
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  site_rates::Vector{Float64})
  return simulate(tree,
                  mod,
                  Sequence(convert(Array{Bool, 2}, rand(Multinomial(1, mod.π), length(site_rates)))),
                  site_rates)
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  seq_length::Int64)
  return simulate(tree,
                  mod,
                  Sequence(convert(Array{Bool, 2}, rand(Multinomial(1, mod.π), seq_length))))
end
