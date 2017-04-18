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
                    print(io, "[root $node]-->[branch \"$b\"]")
                elseif i == 1
                    print(io, "[root $node]-->[branch \"$b\"]\n")
                elseif i < _outdegree(object)
                    print(io, "$blank-->[branch \"$b\"]\n")
                else
                    print(io, "$blank-->[branch \"$b\"]")
                end
            end
        else
            print(io, "[unattached $node]")
        end
    else
        if _outdegree(object) == 0
            print(io, "[branch \"$(_getinbound(object))\"]-->[leaf $node]")
        elseif _hasinbound(object)
            blank = repeat(" ",
                           length("[branch \"$(_getinbound(object))\"]-->[internal $node]") +
                           (isempty(n) ? 0 : 1))
            for (i, b) in zip(1:_outdegree(object), _getoutbounds(object))
                if _outdegree(object) == 1
                    print(io, "[branch \"$(_getinbound(object))\"]-->[internal $node]-->[branch \"$b\"]")
                elseif i == 1
                    print(io, "[branch \"$(_getinbound(object))\"]-->[internal $node]-->[branch \"$b\"]\n")
                elseif i < _outdegree(object)
                    print(io, "$blank-->[branch \"$b\"]\n")
                else
                    print(io, "$blank-->[branch \"$b\"]")
                end
            end
        end
    end
end

function show{N <: AbstractNode, NT}(io::IO, p::Pair{NT, N})
    show(io, p[2], "$(p[1])")
end

function show(io::IO, object::Branch{Int})  
    print(io, "[node $(_getsource(object))]-->[$(_getlength(object)) length branch]-->[node $(_gettarget(object))]")   
end  
 
function show(io::IO, object::Branch)  
    print(io, "[node \"$(_getsource(object))\"]-->[$(_getlength(object)) length branch]-->[node \"$(_gettarget(object))\"]")   
end  
 
function show(io::IO, p::Pair{Int, Branch{Int}})
    print(io, "[node $(_getsource(p[2]))]-->[$(_getlength(p[2])) length branch $(p[1])]-->[node $(_gettarget(p[2]))]")
end

function show{NT, BT}(io::IO, p::Pair{BT, Branch{NT}})
    print(io, "[node \"$(_getsource(p[2]))\"]-->[$(_getlength(p[2])) length branch \"$(p[1])\"]-->[node \"$(_gettarget(p[2]))\"]")
end

function show(io::IO, object::AbstractTree)
    print(io, "Phylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches")
end

function show(io::IO, object::NamedTree)
    if get(io, :compact, false) 
        print(io, "NamedTree phylogenetic tree with $(length(getnodes(object))) nodes ($(length(getleafrecords(object))) leaves) and $(length(getbranches(object))) branches")
    else
        print(io, "NamedTree phylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches\n") 
        print(io, "Leaf names:\n")
        print(io, keys(getleafrecords(object)))
    end
end

function show{ND}(io::IO, object::NodeTree{ND})
    if get(io, :compact, false) 
        print(io, "$(string(typeof(object))) phylogenetic tree with $(length(getnodes(object))) nodes ($(length(getleafrecords(object))) leaves) and $(length(getbranches(object))) branches")
    else
        print(io, "$(string(typeof(object))) phylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches\n") 
        print(io, "Leaf names:\n")
        print(io, keys(getleafrecords(object)))
    end
end
