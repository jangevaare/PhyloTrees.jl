"""
    distance(tree::Tree, node1, node2)

Distance between two `Node`s on a `Tree`
"""
function distance(tree::AbstractTree, node1, node2)
    path = branchpath(tree, node1, node2)
    dist = 0.0
    for b in path
        dist += getlength(tree, b)
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
    distance(tree::Tree, nodes::AbstractVector)

Distance between a `Node` and it's associated root
"""
function distance(tree::AbstractTree, nodes::AbstractVector)
    return map(node -> distance(tree, node), nodes)
end

"""
    distance(tree::Tree, node)

Distance between a `Node` and it's associated root
"""
function distance(tree::AbstractTree, node)
    path = branchpath(tree, node)
    dist = 0.0
    for b in path
        dist += getlength(tree, b)
    end
    return dist
end

function getrootdistance(tree::AbstractTree, label)
    return mapreduce(branch -> getlength(tree, branch), +, 0.0,
                     branchpath(tree, label))
end
