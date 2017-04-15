function show(io::IO, object::AbstractNode)
  if !hasinbound(object)
    if countoutbounds(object) > 0
      for (i, b) in zip(1:countoutbounds, getoutbounds(object))
        if i == 1
          print(io, "\r\e[0m[\e[1mroot node\e[0m]-->[branch $b]")
        elseif i < length(object.out)
          print(io, "\n\e[0m$(repeat(' ', length('[root node]')))-->[branch $b]")
        else
          print(io, "\n\e[0m$(repeat(' ', length('[root node]')))-->[branch $b]")
        end
      end
    else
      print(io, "\r\e[0m[\e[1munattached node\e[0m]")
    end
  else
    if countoutbounds(object) == 0
      print(io, "\r\e[0m[branch $(getinbound(object))]-->[\e[1mleaf node\e[0m]")
    elseif hasinbound(object)
      for (i, b) in zip(1:countoutbounds, getoutbounds(object))
        if countoutbounds(object) == 1
          print(io, "\r\e[0m[branch $(getinbound(object))]-->[\e[1minternal node\e[0m]-->[branch $b]")
        elseif i == 1
          print(io, "\r\e[0m[branch $(getinbound(object))]-->[\e[1minternal node\e[0m]-->[branch $b]")
        elseif i < countoutbounds(object)
          print(io, "\n\e[0m$(repeat(' ', length('[branch $(getinbound(object))]-->[internal node]')))-->[branch $b]")
        else
          print(io, "\n\e[0m$(repeat(' ', length('[branch $(getinbound(object))]-->[internal node]')))-->[branch $b]")
        end
      end
    end
  end
end

function show(io::IO, object::Branch)
  print(io, "\r\e[0m[node $(getsource(object))]-->[\e[1m$(getlength(object)) branch\e[0m]-->[node $(gettarget(object))]")
end


function show(io::IO, object::AbstractTree)
  print(io, "\r\e[0mPhylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches")
end
