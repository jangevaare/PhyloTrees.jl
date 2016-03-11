"""
Tamura and Nei 1993 substitution model

Θ = [α1, α2, β]
"""
type TN93 <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function TN93(Θ::Vector{Float64}, π::Vector{Float64})
    if length(Θ) !== 3
      error("Θ must be of length 3")
    end

    if any(Θ[1:2] .<= 0)
      error("α must be > 0")
    end

    if Θ[3] <= 0
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


function Q(tn93::TN93)
  α1 = tn93.Θ[1]
  α2 = tn93.Θ[1]
  β = tn93.Θ[3]
  # TODO
end


function P(tn93::TN93, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  α1 = tn93.Θ[1]
  α2 = tn93.Θ[1]
  β = tn93.Θ[3]
  # TODO
end
