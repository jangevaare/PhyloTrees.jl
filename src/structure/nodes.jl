"""
Node of phylogenetic tree
"""
type Node
  in::Vector{Int64}
  out::Vector{Int64}

  Node() = new(Int64[], Int64[])
end


function show(io::IO, object::Node)
  if length(object.in) == 0
    for i in 1:length(object.out)
      if i == 1
        print(io, "\r\e[0m[\e[1mroot node\e[0m]-->[branch $(object.out[i])]")
      elseif i < length(object.out)
        print(io, "\n\e[0m$(repeat(" ", length("[root node]")))-->[branch $(object.out[i])]")
      else
        print(io, "\n\e[0m$(repeat(" ", length("[root node]")))-->[branch $(object.out[i])]")
      end
    end
  elseif length(object.in) == 1
    if length(object.out) == 0
      print(io, "\r\e[0m[branch $(object.in[1])]-->[\e[1mleaf node\e[0m]")
    elseif length(object.in) == 1
      for i in 1:length(object.out)
        if length(object.out) == 1
          print(io, "\r\e[0m[branch $(object.in[1])]-->[\e[1minternal node\e[0m]-->[branch $(object.out[i])]")
        elseif i == 1
          print(io, "\r\e[0m[branch $(object.in[1])]-->[\e[1minternal node\e[0m]-->[branch $(object.out[i])]")
        elseif i < length(object.out)
          print(io, "\n\e[0m$(repeat(" ", length("[branch $(object.in[1])]-->[internal node]")))-->[branch $(object.out[i])]")
        else
          print(io, "\n\e[0m$(repeat(" ", length("[branch $(object.in[1])]-->[internal node]")))-->[branch $(object.out[i])]")
        end
      end
    else
      throw("Unknown node type")
    end
  else
    throw("Unknown node type")
  end
end
