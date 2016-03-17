"""
Kimura 1980 substitution model

Θ = [α, β]
"""
type K80 <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function K80(Θ::Vector{Float64})
    if length(Θ) !== 2
      error("Θ must be of length 2")
    end

    if Θ[1] <= 0.
      error("α must be > 0")
    end

    if Θ[2] <= 0.
      error("β must be > 0")
    end

    π = [0.25, 0.25, 0.25, 0.25]
    new(Θ, π)
  end
end


function Q(k80::K80)
  α = k80.Θ[1]
  β = k80.Θ[2]

  return [[-(α + 2 * β) α β β]
          [α -(α + 2 * β) β β]
          [β β -(α + 2 * β) α]
          [β β α -(α + 2 * β)]]
end


function P(k80::K80, t::Float64)
  if t < 0
    error("Time must be positive")
  end

  α = k80.Θ[1]
  β = k80.Θ[2]

  P_0 = 0.25 + 0.25 * exp(-4 * β * t) + 0.5 * exp(-2 * (α + β) * t)
  P_1 = 0.25 + 0.25 * exp(-4 * β * t) - 0.5 * exp(-2 * (α + β) * t)
  P_2 = 0.25 - 0.25 * exp(-4 * β * t)

  return [[P_0 P_1 P_2 P_2]
          [P_1 P_0 P_2 P_2]
          [P_2 P_2 P_0 P_1]
          [P_2 P_2 P_1 P_0]]
end
