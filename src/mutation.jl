abstract Substitution_Model


"""
Jukes and Cantor 1969 substitution model
"""
type JC69 <: Substitution_Model
  λ::Float64
end


"""
Kimura 1980 substitution model
"""
type K80 <: Substitution_Model
  α::Float64
  β::Float64
end


"""
Felsenstein 1981 substitution model
"""
type F81 <: Substitution_Model
end


"""
Felsenstein 1984 substitution model
"""
type F84 <: Substitution_Model
end


"""
Hasegawa et al. 1984, 1985 substitution model
"""
type HKY85 <: Substitution_Model
end


"""
Tamura and Nei 1993 substitution model
"""
type TN93 <: Substitution_Model
end


"""
Generalised time reversible substitution model (Tavaré 1986)
"""
type GTR <: Substitution_Model
end

"""
Unrestricted substitution model
"""
type UNREST <: Substitution_Model
end
