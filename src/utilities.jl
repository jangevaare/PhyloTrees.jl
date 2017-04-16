"""
        indegree(tree::Tree,
                 node::Int)

Determine the in degree of a `Node`
"""
function indegree(tree::AbstractTree,
                  node::Int)
    if !haskey(getnodes(tree), node)
        error("Node does not exist")
    end
    return hasinbound(getnodes(tree)[node]) ? 1 : 0
end


"""
    outdegree(tree::AbstractTree,
              node::Int)

Determine the out degree of a `Node`
"""
function outdegree(tree::AbstractTree,
                   node::Int)
    if !haskey(getnodes(tree), node)
        error("Node does not exist")
    end
    return countoutbounds(getnodes(tree)[node])
end


"""
    isroot(tree::Tree,
           node::Int)

Determine if a `Node` is a root `Node`
"""
function isroot(tree::AbstractTree,
                node::Int)
    return outdegree(tree, node) > 0 && indegree(tree, node) == 0
end


"""
    isleaf(tree::AbstractTree,
           node::Int)

Determine if a `Node` is a leaf `Node`
"""
function isleaf(tree::AbstractTree,
                node::Int)
    return outdegree(tree, node) == 0 && indegree(tree, node) == 1
end


"""
    isnode(tree::AbstractTree,
           node::Int)

Determine if a `Node` is an internal `Node`
"""
function isnode(tree::AbstractTree,
                node::Int)
    return outdegree(tree, node) > 0 && indegree(tree, node) == 1
end


"""
    nodetype(tree::Tree,
             node::Int)

Determine if a `Node` is an internal, root, or leaf `Node`
"""
function nodetype(tree::AbstractTree,
                  node::Int)
    ins = indegree(tree, node)
    outs = outdegree(tree, node)
    if ins == 0
        if outs == 0
            return "Unattached"
        else
            return "Root"
        end
    elseif ins == 1
        if outs == 0
            return "Leaf"
        elseif outs > 0
            return "Internal"
        else
            error("Unknown node type")
        end
    else
        error("Unknown node type")
    end
end


"""
    findroots(tree::AbstractTree)

Find the root `Node`s of a `Tree`
"""
function findroots(tree::AbstractTree)
    roots = Int[]
    for i in keys(getnodes(tree))
        if isroot(tree, i)
            push!(roots, i)
        end
    end
    if length(roots) == 0
        warn("No roots detected")
    end
    return roots
end


"""
    findleaves(tree::AbstractTree)

Find the leaf `Node`s of a `Tree`
"""
function findleaves(tree::AbstractTree)
    leaves = Int[]
    for i in keys(getnodes(tree))
        if isleaf(tree, i)
            push!(leaves, i)
        end
    end
    if length(leaves) == 0
        warn("No leaves detected")
    end
    return leaves
end


"""
    findnodes(tree::AbstractTree)

Find the internal `Node`s of a `Tree`
"""
function findnodes(tree::AbstractTree)
    nodes = Int[]
    for i in keys(getnodes(tree))
        if isnode(tree, i)
            push!(nodes, i)
        end
    end
    if length(nodes) == 0
        warn("No internal nodes detected")
    end
    return nodes
end


"""
    findnonroots(tree::AbstractTree)

Find the non-root `Node`s of a `Tree`
"""
function findnonroots(tree::AbstractTree)
    nonroots = Int[]
    for i in keys(getnodes(tree))
        if !isroot(tree, i)
            push!(nonroots, i)
        end
    end
    if length(nonroots) == 0
        warn("No non-roots detected")
    end
    return nonroots
end


"""
    findnonleaves(tree::AbstractTree)

Find the non-leaf `Node`s of a `Tree`
"""
function findnonleaves(tree::AbstractTree)
    nonleaves = Int[]
    for i in 1:keys(getnodes(tree))
        if !isleaf(tree, i)
            push!(nonleaves, i)
        end
    end
    if length(nonleaves) == 0
        warn("No non-leaves detected")
    end
    return nonleaves
end


"""
    findnonnodes(tree::AbstractTree)

Find the non-internal `Node`s of a `Tree`
"""
function findnonnodes(tree::AbstractTree)
    nonnodes = Int[]
    for i in keys(getnodes(tree))
        if !isnode(tree, i)
            push!(nonnodes, i)
        end
    end
    if length(nonnodes) == 0
        warn("No non-internal nodes detected")
    end
    return nonnodes
end


"""
    parentnode(tree::AbstractTree,
               node::Int)

Find parent `Node`
"""
function parentnode(tree::AbstractTree,
                    node::Int)
    if indegree(tree, node) == 1
        return getsource(tree, getinbound(tree, node))
    else
        error("In degree of specified node != 1")
    end
end


"""
    childnodes(tree::AbstractTree,
               node::Int)

Find child `Node`s
"""
function childnodes(tree::AbstractTree,
                    node::Int)
    if !haskey(getnodes(tree), node)
        error("Node does not exist")
    end
    nodes = Int[]
    for b in getoutbounds(tree, node)
        push!(nodes, gettarget(tree, b))
    end
    return nodes
end


"""
    descendantnodes(tree::AbstractTree,
                    node::Int)

Find descendant `Node`s
"""
function descendantnodes(tree::AbstractTree,
                         node::Int)
    nodecount = [0]
    nodelist = [node]
    while nodecount[end] < length(nodelist)
        push!(nodecount, length(nodelist))
        for i in nodelist[(nodecount[end-1]+1):nodecount[end]]
            append!(nodelist, childnodes(tree, i))
        end
    end
    return nodelist[2:end]
end


"""
    descendantcount(tree::AbstractTree,
                    node::Int)

Find the number of descendant `Nodes`
"""
function descendantcount(tree::AbstractTree,
                         node::Int)
    return length(descendantnodes(tree, node))
end


"""
    descendantcount(tree::AbstractTree,
                    nodes::Array{Int})

Find the number of descendant `Nodes`
"""
function descendantcount(tree::AbstractTree,
                         nodes::Array{Int})
    count = fill(0, size(nodes))
    for i in eachindex(nodes)
        count[i] += descendantcount(tree, nodes[i])
    end
    return count
end


"""
    nodepath(tree::AbstractTree,
             node::Int)

`Node` pathway through which a specified `Node` connects to a root
"""
function nodepath(tree::AbstractTree,
                  node::Int)
    path = [node]
    while isleaf(tree, path[end]) || isnode(tree, path[end])
        push!(path, parentnode(tree, path[end]))
    end
    return path
end


"""
    ancestornodes(tree::AbstractTree,
                  node::Int)

Find ancestral `Node`s
"""
function ancestornodes(tree::AbstractTree,
                       node::Int)
    return nodepath(tree, node)[2:end]
end


"""
    ancestorcount(tree::AbstractTree,
                  node::Int)

Number of ancestral `Node`s
"""
function ancestorcount(tree::AbstractTree,
                       node::Int)
    return length(ancestornodes(tree, node))
end


"""
    ancestorcount(tree::AbstractTree,
                  node::Array{Int})

Number of ancestral `Node`s
"""
function ancestorcount(tree::AbstractTree, nodes::Array{Int})
    count = fill(0, size(nodes))
    for i in eachindex(nodes)
        count[i] += ancestorcount(tree, nodes[i])
    end
    return count
end


"""
    noderoot(tree::AbstractTree,
             node::Int)

The root associated with a specified `Node`
"""
function noderoot(tree::AbstractTree,
                  node::Int)
    return nodepath(tree, node)[end]
end


"""
    areconnected(tree::AbstractTree,
                 node1::Int,
                 node2::Int)

Check for connectedness of two `Node`s
"""
function areconnected(tree::AbstractTree,
                      node1::Int,
                      node2::Int)
    return noderoot(tree, node1) == noderoot(tree, node2)
end


"""
    nodepath(tree::AbstractTree,
             node1::Int,
             node2::Int)

`Node` pathway through which two specified `Node`s connect
"""
function nodepath(tree::AbstractTree,
                  node1::Int,
                  node2::Int)
    if !areconnected(tree, node1, node2)
        error("Nodes are not connected")
    end
    path1 = reverse(nodepath(tree, node1))
    path2 = reverse(nodepath(tree, node2))
    minlength = minimum([length(path1), length(path2)])
    mrcnode_index = findlast(path1[1:minlength] .== path2[1:minlength])
    return [reverse(path1[(mrcnode_index+1):end]); path2[mrcnode_index:end]]
end


"""
    branchpath(tree::AbstractTree,
               node::Int)

Branch pathway through which a specified node connects to a root
"""
function branchpath(tree::AbstractTree,
                    node::Int)
    path = Int[]
    while isleaf(tree, node) || isnode(tree, node)
        push!(path, getinbound(tree, node))
        node = getsource(tree, path[end])
    end
    return path
end


"""
    branchpath(tree::AbstractTree,
               node1::Int,
               node2::Int)

Branch pathway through which two specified nodes connect
"""
function branchpath(tree::AbstractTree,
                    node1::Int,
                    node2::Int)
    if !areconnected(tree, node1, node2)
        error("Nodes are not connected")
    end
    path1 = reverse(branchpath(tree, node1))
    path2 = reverse(branchpath(tree, node2))
    minlength = minimum([length(path1), length(path2)])
    if minlength == 0
        mrcbranch_index = 0
    else
        mrcbranch_index = findlast(path1[1:minlength] .== path2[1:minlength])
    end
    return [reverse(path1[(mrcbranch_index+1):end]); path2[mrcbranch_index+1:end]]
end
