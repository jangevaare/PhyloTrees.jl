"""
Unrestricted substitution model (Yang 1994)

Θ = [a, b, c, d, e, f, g, h, i, j, k, l]
"""
type UNREST <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function UNREST(Θ::Vector{Float64})
    if length(Θ) !== 12
      error("Θ must be of length 12")
    end

    if any(Θ .<= 0)
      error("a, b, c, d, e, f, g, h, i, j, k and l must all be > 0")
    end

    a = Θ[1]
    b = Θ[2]
    c = Θ[3]
    d = Θ[4]
    e = Θ[5]
    f = Θ[6]
    g = Θ[7]
    h = Θ[8]
    i = Θ[9]
    j = Θ[10]
    k = Θ[11]
    l = Θ[12]

    # Approximate solution (Singh et al. 2009)
    # 10.1093/molbev/msp071
    #
    #  π = [(a + d)/(2 * (a + b + d + e)),
    #       (b + c)/(2 * (a + b + d + e)),
    #       (a + d)/(2 * (a + b + d + e)),
    #       (b + c)/(2 * (a + b + d + e))]

    π = [1 0 0 0] * expm([[-(a + b + c) a b c]
                          [d -(d + e + f) e f]
                          [g h -(g + h + i) i]
                          [j k l -(j + k + l)]] * Inf)

    new(Θ, π)
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
