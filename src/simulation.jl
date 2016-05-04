"""
Simulate sequences for all nodes in a phylogenetic tree following a specified
substitution model
"""
function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  root_seq::Array{Bool, 2},
                  site_rates::Vector{Float64})
  seq_length = size(root_seq, 2)

  # Error checking
  if size(root_seq, 1) !== 4
    error("Invalid root sequence format")
  end
  if seq_length != length(site_rates)
    error("Dimension of root sequence must match length of site rates")
  end
  if sum(root_seq) > seq_length
    error("Invalid root sequence")
  end

  # Initialize sequence array
  seq = fill(false, (4, seq_length, length(tree.nodes)))
  visit_order = reverse(postorder(tree))

  # Set root sequence
  seq[:,:,visit_order[1]] = root_seq

  # Iterate through remaining nodes
  for i in visit_order[2:end]
    source = tree.branches[tree.nodes[i].in[1]].source
    branch_length = tree.branches[tree.nodes[i].in[1]].length
    for j in 1:seq_length
      site_rate = site_rates[j]
      p = P(mod, branch_length * site_rate)
      seq[:,j,i] = rand(Multinomial(1, (seq[:,j,source]' * p)[:]))
    end
  end
  return seq
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  root_seq::Array{Bool, 2})
  return simulate(tree,
                  mod,
                  root_seq,
                  fill(1., size(root_seq, 2)))
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  seq_length::Int64,
                  site_rates::Vector{Float64})
  return simulate(tree,
                  mod,
                  convert(Array{Bool, 2}, rand(Multinomial(1, mod.π), seq_length)),
                  site_rates)
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  site_rates::Vector{Float64})
  return simulate(tree,
                  mod,
                  convert(Array{Bool, 2}, rand(Multinomial(1, mod.π), length(site_rates))),
                  site_rates)
end


function simulate(tree::Tree,
                  mod::SubstitutionModel,
                  seq_length::Int64)
  return simulate(tree,
                  mod,
                  convert(Array{Bool, 2}, rand(Multinomial(1, mod.π), seq_length)))
end
