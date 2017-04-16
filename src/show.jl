function show(io::IO, object::AbstractNode, n::Nullable{Int} = Nullable{Int}())
    node = "node"
    if !isnull(n)
        node *= " $(get(n))"
    end
    if !hasinbound(object)
        if countoutbounds(object) > 0
            blank = repeat(" ", length("[root $node]") + (isnull(n) ? 0 : 1))
            for (i, b) in zip(1:countoutbounds(object), getoutbounds(object))
                if countoutbounds(object) == 1
                    print(io, "\e[0m[\e[1mroot $node\e[0m]-->[branch $b]")
                elseif i == 1
                    print(io, "\e[0m[\e[1mroot $node\e[0m]-->[branch $b]\n")
                elseif i < countoutbounds(object)
                    print(io, "\e[0m$blank-->[branch $b]\n")
                else
                    print(io, "\e[0m$blank-->[branch $b]")
                end
            end
        else
            print(io, "\e[0m[\e[1munattached $node\e[0m]")
        end
    else
        if countoutbounds(object) == 0
            print(io, "\e[0m[branch $(getinbound(object))]-->[\e[1mleaf $node\e[0m]")
        elseif hasinbound(object)
            blank = repeat(" ",
                           length("[branch $(getinbound(object))]-->[internal $node]") +
                           (isnull(n) ? 0 : 1))
            for (i, b) in zip(1:countoutbounds(object), getoutbounds(object))
                if countoutbounds(object) == 1
                    print(io, "\e[0m[branch $(getinbound(object))]-->[\e[1minternal $node\e[0m]-->[branch $b]")
                elseif i == 1
                    print(io, "\e[0m[branch $(getinbound(object))]-->[\e[1minternal $node\e[0m]-->[branch $b]\n")
                elseif i < countoutbounds(object)
                    print(io, "\e[0m$blank-->[branch $b]\n")
                else
                    print(io, "\e[0m$blank-->[branch $b]")
                end
            end
        end
    end
end

function show{N <: AbstractNode}(io::IO, p::Pair{Int, N})
    show(io, p[2], Nullable(p[1]))
end

function show(io::IO, object::Branch)
    print(io, "\e[0m[node $(getsource(object))]-->[\e[1m$(getlength(object)) length branch\e[0m]-->[node $(gettarget(object))]")
end

function show(io::IO, p::Pair{Int, Branch})
    print(io, "\e[0m[node $(getsource(p[2]))]-->[\e[1m$(getlength(p[2])) length branch $(p[1])\e[0m]-->[node $(gettarget(p[2]))]")
end

function show(io::IO, object::AbstractTree)
    print(io, "\e[0mPhylogenetic tree with $(length(getnodes(object))) nodes and $(length(getbranches(object))) branches")
end
