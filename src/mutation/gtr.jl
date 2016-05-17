"""
Generalised time reversible substitution model (Tavaré 1986)

Θ = [a, b, c, d, e, f]
"""
type GTR <: SubstitutionModel
  Θ::Vector{Float64}
  π::Vector{Float64}

  function GTR(Θ::Vector{Float64}, π::Vector{Float64})
    if length(Θ) == 6
      a = Θ[1]
      b = Θ[2]
      c = Θ[3]
      d = Θ[4]
      e = Θ[5]
      f = Θ[6]
    else
      error("Θ is not a valid length for GTR model")
    end

    if length(π) !== 4
      error("π must be of length 4")
    end

    if !all(0. .< π .< 1.)
      error("All base proportions must be between 0 and 1")
    end

    if sum(π) !== 1.
      error("Base proportions must sum to 1")
    end

    new([a, b, c, d, e, f], π)
  end
end


function Q(gtr::GTR)
  a = gtr.Θ[1]
  b = gtr.Θ[2]
  c = gtr.Θ[3]
  d = gtr.Θ[4]
  e = gtr.Θ[5]
  f = gtr.Θ[6]

  π_T = gtr.π[1]
  π_C = gtr.π[2]
  π_A = gtr.π[3]
  π_G = gtr.π[4]

  Q_TT = -((a * π_C) + (b * π_A) + (c * π_G))
  Q_TC = a * π_C
  Q_TA = b * π_A
  Q_TG = c * π_G

  Q_CT = a * π_T
  Q_CC = -((a * π_T) + (d * π_A) + (e * π_G))
  Q_CA = d * π_A
  Q_CG = e * π_G

  Q_AT = b * π_T
  Q_AC = d * π_C
  Q_AA = -((b * π_T) + (d * π_C) + (f * π_G))
  Q_AG = f * π_G

  Q_AT = c * π_T
  Q_AC = e * π_C
  Q_AA = f * π_A
  Q_AG = -((c * π_T) + (e * π_C) + (f * π_A))

  return [[Q_TT Q_TC Q_TA Q_TG]
          [Q_CT Q_CC Q_CA Q_CG]
          [Q_AT Q_AC Q_AA Q_AG]
          [Q_GT Q_GC Q_GA Q_GG]]
end


function P(gtr::GTR, t::Float64)
  if t < 0
    error("Time must be positive")
  end

  return expm(Q(gtr)*t)
end
