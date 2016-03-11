"""
Hasegawa et al. 1984 substitution model

Θ= [α, β]
"""
type HKY85 <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function HKY85(Θ::Vector{Float64}, π::Vector{Float64})
    if Θ[1] <= 0
      error("α must be > 0")
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


function Q(hky85:::HKY85)
  α = hky85.Θ[1]
  β = hky85.Θ[2]
  # TODO
end


function P(hky85::HKY85, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  # TODO
end
