type PhyloTrace
  substitution_model::Vector{SubstitutionModel}
  tree::Vector{Tree}
  logposterior::Vector{Float64}
end


type PhyloIteration
  substitution_model::SubstitutionModel
  tree::Tree
  logposterior::Float64
end


PhyloProposal = PhyloIteration


function push!(trace::PhyloTrace, iteration::PhyloIteration)
  push!(trace.substitution_model, iteration.substitution_model)
  push!(trace.tree, iteration.tree)
  push!(trace.logposterior, iteration.logposterior)
end


function append!(trace1::PhyloTrace, trace2::PhyloTrace)
  append!(trace1.substitution_model, trace2.substitution_model)
  append!(trace1.tree, trace2.tree)
  append!(trace1.logposterior, trace2.logposterior)
end


"""
Generate the variance-covariance matrix for a MvNormal transition kernel based
upon prior distributions
"""
function transition_kernel_variance(x::SubstitutionModelPriors)
  diagonal = Float64[]
  for i in x.Θ
    push!(diagonal, var(i)*2.38^2)
  end
  diagonal /= length(diagonal)
  return diagm(diagonal)
end


"""
Adapt the variance-covariance matrix for a MvNormal transition kernel for
`SubstitutionModel`
"""
function transition_kernel_variance(x::Vector{SubstitutionModel})
  covariance_matrix = cov([x[i].Θ for i = 1:length(x)])
  return covariance_matrix * (2.38^2) / size(covariance_matrix, 1)
end


"""
Generate a `SubstitutionModel` proposal using the multivariate normal
distribution as the transition kernel, with a previous set of
`SubstitutionModel` parameters as the mean vector and a transition kernel
variance as the variance-covariance matrix
"""
function propose(currentstate::SubstitutionModel,
                 transition_kernel_variance::Array{Float64, 2})
  newstate = rand(MvNormal(currentstate.Θ, transition_kernel_variance))
  # TODO
  return typeof(currentstate)(newstate)
end
