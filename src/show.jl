function show(io::IO, object::AbstractNode, n::String = "")
    node = "node"
    if !isempty(n)
        node *= " \"$n\""
    end
    if !_hasinbound(object)
        if _outdegree(object) > 0
            blank = repeat(" ", length("[root $node]") + (isempty(n) ? 0 : 1))
            for (i, b) in zip(1:_outdegree(object), _getoutbounds(object))
                if _outdegree(object) == 1
                    print(io, "\e[0m[\e[1mroot $node\e[0m]-->[branch \"$b\"]")
                elseif i == 1
                    print(io, "\e[0m[\e[1mroot $node\e[0m]-->[branch \"$b\"]\n")
                elseif i < _outdegree(object)
                    print(io, "\e[0m$blank-->[branch \"$b\"]\n")
                else
                    print(io, "\e[0m$blank-->[branch \"$b\"]")
                end
            end
        else
            print(io, "\e[0m[\e[1munattached $node\e[0m]")
        end
    else
        if _outdegree(object) == 0
            print(io, "\e[0m[branch \"$(_getinbound(object))\"]-->[\e[1mleaf $node\e[0m]")
        elseif _hasinbound(object)
            blank = repeat(" ",
                           length("[branch \"$(_getinbound(object))\"]-->[internal $node]") +
                           (isempty(n) ? 0 : 1))
            for (i, b) in zip(1:_outdegree(object), _getoutbounds(object))
                if _outdegree(object) == 1
                    print(io, "\e[0m[branch \"$(_getinbound(object))\"]-->[\e[1minternal $node\e[0m]-->[branch \"$b\"]")
                elseif i == 1
                    print(io, "\e[0m[branch \"$(_getinbound(object))\"]-->[\e[1minternal $node\e[0m]-->[branch \"$b\"]\n")
                elseif i < _outdegree(object)
                    print(io, "\e[0m$blank-->[branch \"$b\"]\n")
                else
                    print(io, "\e[0m$blank-->[branch \"$b\"]")
                end
            end
        end
    end
end

function show{N <: AbstractNode, NT}(io::IO, p::Pair{NT, N})
    show(io, p[2], "$(p[1])")
end

function show(io::IO, object::Branch)
    print(io, "\e[0m[node \"$(_getsource(object))\"]-->[\e[1m$(_getlength(object)) length branch\e[0m]-->[node \"$(_gettarget(object))\"]")
end

function show{NT, BT}(io::IO, p::Pair{BT, Branch{NT}})
    print(io, "\e[0m[node \"$(_getsource(p[2]))\"]-->[\e[1m$(_getlength(p[2])) length branch \"$(p[1])\"\e[0m]-->[node \"$(_gettarget(p[2]))\"]")
end

function show(io::IO, object::AbstractTree)
    print(io, "\e[0mPhylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches")
end

function show(io::IO, object::NamedTree)
    print(io, "\e[0mPhylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches\n")
    print(io, "Leaf names:\n")
    show(io, keys(getleafrecords(object)))
end
