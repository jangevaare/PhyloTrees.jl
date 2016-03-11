""""
Felsenstein 1984 substitution model

Θ = [κ, β]
"""
type F84 <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function F84(Θ::Vector{Float64}, π::Vector{Float64})
    if length(Θ) !== 2
      error("Θ must have a length of 2")
    end
    if Θ[1] <= 0
      error("κ must be > 0")
    end

    if Θ[2] <= 0
      error("β must be > 0")
    end

    if length(π) !== 4
      error("π must be of length 4")
    end

    if !all(0 .< π .< 1)
      error("All base proportions must be between 0 and 1")
    end

    if sum(π) !== 1
      error("Base proportions must sum to 1")
    end

    new(Θ, π)
  end
end


function Q(f84::F84)
  # TODO
end


function P(f84::F84, t::Float64)
  if t < 0
    error("Time must be positive")
  end

  return # TODO
end
