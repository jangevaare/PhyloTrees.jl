type PhyloTrace
  substitutionmodel::Vector{SubstitutionModel}
  tree::Vector{Tree}
  logposterior::Vector{Float64}
end


type PhyloIteration
  substitutionmodel::SubstitutionModel
  tree::Tree
  logposterior::Float64
end


PhyloProposal = PhyloIteration


function push!(trace::PhyloTrace, iteration::PhyloIteration)
  push!(trace.substitutionmodel, iteration.substitutionmodel)
  push!(trace.tree, iteration.tree)
  push!(trace.logposterior, iteration.logposterior)
end


function append!(trace1::PhyloTrace, trace2::PhyloTrace)
  append!(trace1.substitutionmodel, trace2.substitutionmodel)
  append!(trace1.tree, trace2.tree)
  append!(trace1.logposterior, trace2.logposterior)
end


"""
Generate the variance-covariance matrix for a MvNormal transition kernel based
upon prior distributions
"""
function transition_kernel_variance(x::SubstitutionModelPrior)
  diagonal = Float64[]
  for i in x.Θ
    push!(diagonal, var(i)*2.38^2)
  end
  return diagonal
end


"""
Adapt the variance-covariance matrix for a MvNormal transition kernel for
`SubstitutionModel`
"""
function transition_kernel_variance(x::Vector{SubstitutionModel})
  covariance_matrix = cov([x[i].Θ for i = 1:length(x)])
  kernel_var = covariance_matrix * (2.38^2) / size(covariance_matrix, 1)
  return diag(kernel_var)
end


"""
Generate a `SubstitutionModel` proposal using the multivariate normal
distribution as the transition kernel, with a previous set of
`SubstitutionModel` parameters as the mean vector and a transition kernel
variance as the variance-covariance matrix
"""
function propose(currentstate::SubstitutionModel,
                 substitutionmodel_prior::SubstitutionModelPrior,
                 variance::Vector{Float64})
  newstate = currentstate
  for i in 1:length(substitutionmodel_prior.Θ)
    lb = support(substitutionmodel_prior.Θ[i]).lb
    ub = support(substitutionmodel_prior.Θ[i]).ub
    newstate.Θ[i] = rand(Truncated(Normal(currentstate.Θ[i], variance[i]), lb, ub))
  end
  if length(fieldnames(substitutionmodel_prior)) == 2
    newstate.π = rand(Dirichlet([5; 5; 5; 5]))
  end
  return newstate
end
