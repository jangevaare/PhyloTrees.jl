module Phylogenetics

  using Distributions, Graphs

  export
  Tree,
  Node

  include("type.jl")
  include("simulate.jl")
  include("infer.jl")
end
