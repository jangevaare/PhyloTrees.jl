import Base.show

function show(io::IO, object::Tree)
  print(io, "\r\e[0mPhylogenetic tree with $(length(object.nodes)) nodes and $(length(object.branches)) branches")
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
      error("Unknown node type")
    end
  else
    error("Unknown node type")
  end
end


function show(io::IO, object::Branch)
  print(io, "\r\e[0m[node $(object.source)]-->[\e[1m$(object.length) branch\e[0m]-->[node $(object.target)]")
end


function show(io::IO, object::JC69)
  print(io, "\r\e[0m\e[1mJ\e[0mukes and \e[1mC\e[0mantor 19\e[1m69\e[0m substitution model\n$(Q(object))")
end


function show(io::IO, object::K80)
  print(io, "\r\e[0m\e[1mK\e[0mimura 19\e[1m80\e[0m substitution model\n$(Q(object))")
end


function show(io::IO, object::F81)
  print(io, "\r\e[0m\e[1mF\e[0melsenstein 19\e[1m81\e[0m substitution model\n$(Q(object))")
end


function show(io::IO, object::F84)
  print(io, "\r\e[0m\e[1mF\e[0melsenstein 19\e[1m84\e[0m substitution model\n$(Q(object))")

end


function show(io::IO, object::HKY85)
  print(io, "\r\e[0m\e[1mH\e[0masegawa \e[1mK\e[0mishino, and \e[1mY\e[0mano 19\e[1m85\e[0m substitution model \n$(Q(object))")
end


function show(io::IO, object::TN93)
  print(io, "\r\e[0m\e[1mT\e[0mamura, and \e[1mN\e[0mei 19\e[1m93\e[0m substitution model \n$(Q(object))")
end


function show(io::IO, object::GTR)
  print(io, "\r\e[0m\e[1mG\e[0meneralised \e[1mT\e[0mime \e[1mR\e[0meversible substitution model \n$(Q(object))")
end
