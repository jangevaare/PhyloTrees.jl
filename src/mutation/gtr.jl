"""
Generalised time reversible substitution model (Tavaré 1986)

Θ = [a, b, c, d, e, f]
"""
type GTR <: Substitution_Model
  Θ::Vector{Float64}
  π::Vector{Float64}

  function GTR(Θ::Vector{Float64}, π::Vector{Float64})
    if length(Θ) !== 6
      error("Θ must be of length 6")
    end

    if any(Θ .<= 0)
      error("a, b, c, d, e and f must all be > 0")
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


function Q(gtr::GTR)
  a = gtr.Θ[1]
  b = gtr.Θ[2]
  c = gtr.Θ[3]
  d = gtr.Θ[4]
  e = gtr.Θ[5]
  f = gtr.Θ[6]
  # TODO
end


function P(gtr::GTR, t::Float64)
  if t < 0
    error("Time must be positive")
  end
  a = gtr.Θ[1]
  b = gtr.Θ[2]
  c = gtr.Θ[3]
  d = gtr.Θ[4]
  e = gtr.Θ[5]
  f = gtr.Θ[6]
  # TODO
end
