type Sequence
  nucleotides::Array{Bool, 2}
  length::Int64

  function Sequence(nucleotides::Array{Bool, 2})
    if size(nucleotides, 1) != 4
      error("Invalid nucleotide array dimensions")
    end
    if sum(nucleotides) != size(nucleotides, 2)
      error("Invalid nucleotide array provided")
    end
    return new(nucleotides, size(nucleotides, 2))
  end

  function Sequence(nucleotides::Vector{Int64})
    nucleotidearray = fill(false, (4, length(nucleotides)))
    for i = 1:length(nucleotides)
      if nucleotides[i] in [1; 2; 3; 4]
        nucleotidearray[nucleotides[i],i] = true
      else
        error("Invalid nucleotide in position $i")
      end
    end
    return new(nucleotidearray, length(nucleotides))
  end

  function Sequence(nucleotides::String)
    nucleotidearray = fill(false, (4, length(nucleotides)))
    for i = 1:length(nucleotides)
      if nucleotides[i] == 'T'
        nucleotidearray[1, i] = true
      elseif nucleotides[i] == 'C'
        nucleotidearray[2, i] = true
      elseif nucleotides[i] == 'A'
        nucleotidearray[3, i] = true
      elseif nucleotides[i] == 'G'
        nucleotidearray[4, i] = true
      else
        error("Invalid nucleotide in position $i")
      end
    end
    return new(nucleotidearray, length(nucleotides))
  end
end


function show(io::IO, object::Sequence)
  if object.length <= 26
    print(io, "TCAG"[[findfirst(object.nucleotides[:,i]) for i=1:object.length]])
  else
    print(io, "TCAG"[[findfirst(object.nucleotides[:,i]) for i=1:13]] * "..." * "TCAG"[[findfirst(object.nucleotides[:,i]) for i=object.length-13:object.length]])
  end
end


function length(x::Sequence)
  return x.length
end


function getindex(x::Sequence, i::Int64)
  return Sequence(x.nucleotides[:,i]'')
end


function getindex(x::Sequence, i::UnitRange{Int64})
  return Sequence(x.nucleotides[:,i])
end


function getindex(x::Sequence, i::Vector{Int64})
  return Sequence(x.nucleotides[:,i])
end
