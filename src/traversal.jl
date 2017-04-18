"""
    postorder(tree::Tree)

    `Node` postorder traversal order
    """
function postorder{NL, TL}(tree::AbstractTree{NL, TL})
    nodes = collect(keys(getnodes(tree)))
    visited = Dict{NL, Bool}(i => false for i in nodes)
    visit_order = NL[]
    next = nodes[findfirst(!collect(values(visited)))]
    while !all(collect(values(visited)))
        sub_visited = Bool[]
        for i in getoutbounds(tree, next)
            push!(sub_visited, visited[gettarget(tree, i)])
        end
        if all(sub_visited) || length(sub_visited) == 0
            push!(visit_order, next)
            visited[next] = true
            if !all(collect(values(visited)))
                if hasinbound(tree, next)
                    next = getsource(tree, getinbound(tree, next))
                else
                    next = nodes[findfirst(!collect(values(visited)))]
                end
            end
        else
            next = gettarget(tree, getoutbounds(tree, next)[!sub_visited][1])
        end
    end
    return visit_order
end
