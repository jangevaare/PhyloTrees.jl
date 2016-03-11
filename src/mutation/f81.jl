"""
Felsenstein 1981 substitution model

Θ = [λ]
"""
type F81 <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function F81(Θ::Vector{Float64}, π::Vector{Float64})
    if length(Θ) !== 1
      error("Θ must have a length of 1")
    end

    if Θ[1] <= 0
      error("λ must be > 0")
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


function Q(f81::F81)
  # TODO
end


function P(f81::F81, t::Float64)
  if t < 0
    error("Time must be positive")
  end

  return # TODO
end
