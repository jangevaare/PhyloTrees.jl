"""
Jukes and Cantor 1969 substitution model

Θ = [λ]
"""
type JC69 <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}
  function JC69(Θ::Vector{Float64})
    if length(Θ) !== 1
      error("Θ must have a length of 1")
    end

    if Θ[1] <= 0.
      error("λ must be > 0")
    end

    π = [0.25, 0.25, 0.25, 0.25]
    new(Θ, π)
  end
end


JC69() = JC69([1.])


function Q(jc69::JC69)
  λ = jc69.Θ[1]

  return [[-3λ λ λ λ]
          [λ -3λ λ λ]
          [λ λ -3λ λ]
          [λ λ λ -3λ]]
end


function P(jc69::JC69, t::Float64)
  if t < 0
    error("Time must be positive")
  end

  λ = jc69.Θ[1]
  p0 = 0.25 + 0.75*exp(-t*λ*4)
  p1 = 0.25 - 0.25*exp(-t*λ*4)

  return [[p0 p1 p1 p1]
          [p1 p0 p1 p1]
          [p1 p1 p0 p1]
          [p1 p1 p1 p0]]
end
