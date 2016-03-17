"""
Unrestricted substitution model (Yang 1994)

Θ = [a, b, c, d, e, f, g, h, i, j, k, l]
"""
type UNREST <: Substitution_Model
  Θ::Vector{Float64}
  # π::Vector{Float64}

  function UNREST(Θ::Vector{Float64})
    if length(Θ) !== 9
      error("Θ must be of length 12")
    end

    if any(Θ .<= 0)
      error("a, b, c, d, e, f, g, h, i, j, k and l must all be > 0")
    end

    # new(Θ, π)
    new(Θ)
  end
end

function Q(unrest::UNREST)
  a = unrest.Θ[1]
  b = unrest.Θ[2]
  c = unrest.Θ[3]
  d = unrest.Θ[4]
  e = unrest.Θ[5]
  f = unrest.Θ[6]
  g = unrest.Θ[7]
  h = unrest.Θ[8]
  i = unrest.Θ[9]
  j = unrest.Θ[10]
  k = unrest.Θ[11]
  l = unrest.Θ[12]

  return [[-(a + b + c) a b c]
          [d -(d + e + f) e f]
          [g h -(g + h + i) i]
          [j k l -(j + k + l)]]
end


function P(unrest::UNREST, t::Float64)
  if t < 0
    error("Time must be positive")
  end

  return expm(Q(unrest)*t)
end
