abstract Substitution_Model


"""
Jukes and Cantor 1969 substitution model
"""
type JC69{T<:Float64} <: Substitution_Model
  λ::T

  function JC69(λ::T)
    if λ <= 0.
      error("λ must be > 0")
    end

    new(λ)
  end
end


"""
Kimura 1980 substitution model
"""
type K80 <: Substitution_Model
  α::Float64
  β::Float64

  function K80(α::T, β::T)
    if α <= 0.
      error("α must be > 0")
    end

    if β <= 0.
      error("β must be > 0")
    end

    new(α, β)
  end
end


"""
Felsenstein 1981 substitution model
"""
type F81{T<:Float64} <: Substitution_Model
  λ::T
  π::Vector{T}

  function F81(β::T, π::Vector{T})
    if λ <= 0
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

    new(λ, π)
  end
end


"""
Felsenstein 1984 substitution model
"""
type F84{T<:Float64} <: Substitution_Model
  κ::T
  β::T
  π::Vector{T}
  function F84(κ::T, β::T, π::Vector{T})
    if κ <= 0
      error("κ must be > 0")
    end

    if β <= 0
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

    new(κ, β, π)
  end
end


"""
Hasegawa et al. 1984, 1985 substitution model
"""
type HKY85{T<:Float64} <: Substitution_Model
  α::T
  β::T
  π::Vector{T}

  function HKY85(α::T, β::T, π::Vector{T})
    if α <= 0
      error("α must be > 0")
    end

    if β <= 0
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

    new(α, β, π)
  end
end


"""
Tamura and Nei 1993 substitution model
"""
type TN93{T<:Float64} <: Substitution_Model
  α::Vector{T}
  β::T
  π::Vector{T}

  function TN93(α::Vector{T}, β::T, π::Vector{T})
    if any(α .<= 0)
      error("α must be > 0")
    end

    if length(α) !== 2
      error("α must be of length 2")
    end

    if β <= 0
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

    new(α, β, π)
  end
end


"""
Generalised time reversible substitution model (Tavaré 1986)
"""
type GTR{T<:Float64} <: Substitution_Model
  a::T
  b::T
  c::T
  d::T
  e::T
  f::T
  π::Vector{T}

  function GTR(a::T, b::T, c::T, d::T, e::T, f::T, π::Vector{T})
    # TODO
    new(a,b,c,f,e,f,π)
  end

end


"""
Unrestricted substitution model (Yang 1994)
"""
type UNREST <: Substitution_Model
  # TODO
end
