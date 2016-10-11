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
