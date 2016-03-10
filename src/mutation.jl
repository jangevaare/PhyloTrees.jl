abstract Substitution_Model


"""
Jukes and Cantor 1969 substitution model
"""
type JC69 <: Substitution_Model
  λ::Float64

  function JC69(λ::Float64)
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

  function K80(α::Float64, β::Float64)
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
type F81 <: Substitution_Model
  β::Float64
  π::Vector{Float64}

  function F81(β::Float64, π::Vector{Float64})
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
    new(β, π)
  end
end


"""
Felsenstein 1984 substitution model
"""
type F84 <: Substitution_Model
  # TODO
end


"""
Hasegawa et al. 1984, 1985 substitution model
"""
type HKY85 <: Substitution_Model
  # TODO
end


"""
Tamura and Nei 1993 substitution model
"""
type TN93 <: Substitution_Model
  # TODO
end


"""
Generalised time reversible substitution model (Tavaré 1986)
"""
type GTR <: Substitution_Model
  # TODO
end

"""
Unrestricted substitution model
"""
type UNREST <: Substitution_Model
  # TODO
end
