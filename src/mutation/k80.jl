"""
Kimura 1980 substitution model
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

  return # TODO
end


function P(k80::K80, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  α = k80.Θ[1]
  β = k80.Θ[2]

  return # TODO
end
