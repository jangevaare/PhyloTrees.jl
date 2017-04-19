"""
    nodetype(tree::Tree, node)

Determine if a `Node` is an internal, root, or leaf `Node`
"""
function nodetype(tree::AbstractTree, node)
    if isunattached(tree, node)
        return "Unattached"
    elseif isroot(tree, node)
        return "Root"
    elseif isleaf(tree, node)
        return "Leaf"
    elseif isinternal(tree, node)
        return "Internal"
    else
        error("Unknown node type")
    end
end

"""
    findunconnecteds(tree::AbstractTree)

Find the root `Node`s of a `Tree`
"""
function findunattacheds{NL, BL}(tree::AbstractTree{NL, BL})
    unattached = NL[]
    for i in keys(getnodes(tree))
        if isunattached(tree, i)
            push!(unattached, i)
        end
    end
    return unattached
end


"""
    findroots(tree::AbstractTree)

Find the root `Node`s of a `Tree`
"""
function findroots{NL, BL}(tree::AbstractTree{NL, BL})
    roots = NL[]
    for i in keys(getnodes(tree))
        if isroot(tree, i)
            push!(roots, i)
        end
    end
    return roots
end

"""
    findleaves(tree::AbstractTree)

Find the leaf `Node`s of a `Tree`
"""
function findleaves{NL, BL}(tree::AbstractTree{NL, BL})
    leaves = NL[]
    for i in keys(getnodes(tree))
        if isleaf(tree, i)
            push!(leaves, i)
        end
    end
    return leaves
end

"""
    findnodes(tree::AbstractTree)

Find the internal `Node`s of a `Tree`
"""
function findnodes{NL, BL}(tree::AbstractTree{NL, BL})
    nodes = NL[]
    for i in keys(getnodes(tree))
        if isnode(tree, i)
            push!(nodes, i)
        end
    end
    return nodes
end

"""
    findnonroots(tree::AbstractTree)

Find the non-root `Node`s of a `Tree`
"""
function findnonroots{NL, BL}(tree::AbstractTree{NL, BL})
    nonroots = NL[]
    for i in keys(getnodes(tree))
        if !isroot(tree, i)
            push!(nonroots, i)
        end
    end
    return nonroots
end

"""
    findnonleaves(tree::AbstractTree)

Find the non-leaf `Node`s of a `Tree`
"""
function findnonleaves{NL, BL}(tree::AbstractTree{NL, BL})
    nonleaves = NL[]
    for i in keys(getnodes(tree))
        if !isleaf(tree, i)
            push!(nonleaves, i)
        end
    end
    return nonleaves
end

"""
    findnonnodes(tree::AbstractTree)

Find the non-internal `Node`s of a `Tree`
"""
function findnonnodes{NL, BL}(tree::AbstractTree{NL, BL})
    nonnodes = NL[]
    for i in keys(getnodes(tree))
        if !isnode(tree, i)
            push!(nonnodes, i)
        end
    end
    return nonnodes
end

"""
    parentnode(tree::AbstractTree, node)

Find parent `Node`
"""
function parentnode(tree::AbstractTree, node)
    if hasinbound(tree, node)
        return getsource(tree, getinbound(tree, node))
    else
        error("In degree of specified node != 1")
    end
end

"""
    childnodes(tree::AbstractTree, node)

Find child `Node`s
"""
function childnodes{NL, BL}(tree::AbstractTree{NL, BL}, node)
    hasnode(tree, node) || error("Node $node does not exist")
    nodes = NL[]
    for b in getoutbounds(tree, node)
        push!(nodes, gettarget(tree, b))
    end
    return nodes
end

"""
    descendantnodes(tree::AbstractTree, node)

Find descendant `Node`s
"""
function descendantnodes(tree::AbstractTree, node)
    nodecount = [0]
    nodelist = [node]
    while last(nodecount) < length(nodelist)
        push!(nodecount, length(nodelist))
        for i in nodelist[(nodecount[end-1]+1):last(nodecount)]
            append!(nodelist, childnodes(tree, i))
        end
    end
    return nodelist[2:end]
end

"""
    descendantcount(tree::AbstractTree, node)

Find the number of descendant `Nodes`
"""
function descendantcount(tree::AbstractTree, node)
    return length(descendantnodes(tree, node))
end


"""
    descendantcount(tree::AbstractTree, nodes::Array{NL})

Find the number of descendant `Nodes`
"""
function descendantcount(tree::AbstractTree, nodes::AbstractArray)
    count = fill(0, size(nodes))
    for i in eachindex(nodes)
        count[i] += descendantcount(tree, nodes[i])
    end
    return count
end

"""
    nodepath(tree::AbstractTree, node)

`Node` pathway through which a specified `Node` connects to a root
"""
function nodepath(tree::AbstractTree, node)
    return append!([node], ancestornodes(tree, node))
end

"""
    ancestornodes(tree::AbstractTree, node)

Find ancestral `Node`s
"""
function ancestornodes{NL, BL}(tree::AbstractTree{NL, BL}, node)
    ancestors = NL[]
    current = node
    while (hasinbound(tree, current))
        current = parentnode(tree, current)
        push!(ancestors, current)
    end
    return ancestors
end

"""
    ancestorcount(tree::AbstractTree, node)

Number of ancestral `Node`s
"""
function ancestorcount(tree::AbstractTree, node)
    return length(ancestornodes(tree, node))
end

"""
    ancestorcount(tree::AbstractTree, node::AbstractArray)

Number of ancestral `Node`s
"""
function ancestorcount(tree::AbstractTree, nodes::AbstractArray)
    return map(node -> ancestorcount(tree, node), nodes)
end

"""
    noderoot(tree::AbstractTree, node)

The root associated with a specified `Node`
"""
function noderoot(tree::AbstractTree, node)
    return last(nodepath(tree, node))
end

"""
    areconnected(tree::AbstractTree, node1, node2)

Check for connectedness of two `Node`s
"""
function areconnected(tree::AbstractTree, node1,  node2)
    return noderoot(tree, node1) == noderoot(tree, node2)
end

"""
    nodepath(tree::AbstractTree, node1, node2)

`Node` pathway through which two specified `Node`s connect
"""
function nodepath(tree::AbstractTree, node1, node2)
    areconnected(tree, node1, node2) ||
        error("Nodes are not connected")
    path1 = reverse(nodepath(tree, node1))
    path2 = reverse(nodepath(tree, node2))
    minlength = minimum([length(path1), length(path2)])
    mrcnode_index = findlast(path1[1:minlength] .== path2[1:minlength])
    return [reverse(path1[(mrcnode_index+1):end]); path2[mrcnode_index:end]]
end

"""
    branchpath(tree::AbstractTree, node)

Branch pathway through which a specified node connects to a root
"""
function branchpath{NL, BL}(tree::AbstractTree{NL, BL}, node)
    path = BL[]
    while hasinbound(tree, node)
        push!(path, getinbound(tree, node))
        node = getsource(tree, last(path))
    end
    return path
end

"""
    branchpath(tree::AbstractTree, node1, node2)

Branch pathway through which two specified nodes connect
"""
function branchpath(tree::AbstractTree, node1, node2)
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
