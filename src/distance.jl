"""
    distance(tree::Tree,
             node1::Int,
             node2::Int)

Distance between two `Node`s on a `Tree`
"""
function distance(tree::AbstractTree,
                  node1::Int,
                  node2::Int)
    path = branchpath(tree, node1, node2)
    dist = 0.0
    for b in path
        dist += getlength(getbranches(tree)[b])
    end
    return dist
end


"""
    distance(tree::Tree)

Pairwise distances between all leaf `Node`s on a `Tree`
"""
function distance(tree::AbstractTree)
    leaves = findleaves(tree)
    return [distance(tree, i, j) for i in leaves, j in leaves]
end


"""
    distance(tree::Tree,
             node::Int)

Distance between a `Node` and it's associated root
"""
function distance(tree::AbstractTree,
                  node::Int)
    path = branchpath(tree, node)
    dist = 0.0
    for b in path
        dist += getlength(getbranches(tree)[b])
    end
    return dist
end
