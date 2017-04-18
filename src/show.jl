function show(io::IO, object::AbstractNode, n::String = "")
    node = "node"
    if !isempty(n)
        node *= " $n"
    end
    if !_hasinbound(object)
        if _outdegree(object) > 0
            blank = repeat(" ", length("[root $node]") + (isempty(n) ? 0 : 1))
            for (i, bn) in zip(1:_outdegree(object), _getoutbounds(object))
                b = typeof(bn) <: Number ? "$bn" : "\"$bn\""
                if _outdegree(object) == 1
                    print(io, "[root $node]-->[branch $b]")
                elseif get(io, :compact, false)
                    if i == 1
                        print(io, "[root $node]-->[branches $b")
                    elseif i < _outdegree(object)
                        print(io, ", $b")
                    else
                        print(io, " and $b]")
                    end
                else # multiline view
                    if i == 1
                        print(io, "[root $node]-->[branch $b]\n")
                    elseif i < _outdegree(object)
                        print(io, "$blank-->[branch $b]\n")
                    else
                        print(io, "$blank-->[branch $b]")
                    end
                end
            end
        else
            print(io, "[unattached $node]")
        end
    else # hasinbound
        inb = typeof(_getinbound(object)) <: Number ? 
            "$(_getinbound(object))" : "\"$(_getinbound(object))\""
        if _outdegree(object) == 0
            print(io, "[branch $inb]-->[leaf $node]")
        elseif _hasinbound(object)
            blank = repeat(" ",
                           length("[branch $inb]-->[internal $node]") +
                           (isempty(n) ? 0 : 1))
            for (i, bn) in zip(1:_outdegree(object), _getoutbounds(object))
                b = typeof(bn) <: Number ? "$bn" : "\"$bn\""
                if _outdegree(object) == 1
                    print(io, "[branch $inb]-->[internal $node]-->[branch $b]")
                elseif get(io, :compact, false)
                    if i == 1
                        print(io, "[branch $inb]-->[internal $node]-->[branches $b")
                    elseif i < _outdegree(object)
                        print(io, ", $b")
                    else
                        print(io, " and $b]")
                    end
                else # multiline view
                    if i == 1
                        print(io, "[branch $inb]-->[internal $node]-->[branch $b]\n")
                    elseif i < _outdegree(object)
                        print(io, "$blank-->[branch $b]\n")
                    else
                        print(io, "$blank-->[branch $b]")
                    end
                end
            end
        end
    end
end

function show{N <: AbstractNode, NT}(io::IO, p::Pair{NT, N})
    n = NT <: Number ? "$(p[1])" : "\"$(p[1])\""
    show(io, p[2], "$n")
end

function show{NT}(io::IO, object::Branch{NT})  
    source = NT <: Number ? "$(_getsource(p[2]))" : "\"$(_getsource(p[2]))\""
    target = NT <: Number ? "$(_gettarget(p[2]))" : "\"$(_gettarget(p[2]))\""
    print(io, "[node $source]-->[$(_getlength(object)) length branch]-->[node $target]")   
end  
 
function show{BT, NT}(io::IO, p::Pair{BT, Branch{NT}})
    source = NT <: Number ? "$(_getsource(p[2]))" : "\"$(_getsource(p[2]))\""
    target = NT <: Number ? "$(_gettarget(p[2]))" : "\"$(_gettarget(p[2]))\""
    branch = BT <: Number ? "$(p[1])" : "\"$(p[1])\""
    print(io, "[node $source]-->[$(_getlength(p[2])) length branch $branch]-->[node $target]")
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

function showall(io::IO, object::AbstractTree)
    print(io, object)
    print(io, "Nodes:\n") 
    print(io, getnodes(object))
    print(io, "Branches:\n") 
    print(io, getbranches(object))
end

function showall{ND}(io::IO, object::NodeTree{ND})
    print(io, object)
    print(io, "\nNodes:\n") 
    print(io, getnodes(object))
    print(io, "\nBranches:\n") 
    print(io, getbranches(object))
    if ND != Void
        print(io, "\nNodeData:\n") 
        print(io, getnoderecords(object))
    end
end
