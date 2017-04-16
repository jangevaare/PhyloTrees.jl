"""
    addnode!(tree::Tree)

Adds a single `Node` to a `Tree`
"""
function addnode!{N <: AbstractNode}(tree::SimpleTree{N}; id::Int = 0)
    node = N()
    if (id > 0)
        checknode(id, node, tree) ||
            error("Can't create known node $id")
    else
        # Find highest node index
        if isempty(getnodes(tree))
            max_node = 0
        else
            max_node = maximum(keys(getnodes(tree)))
        end
        
        # Add the new node
        id = max_node + 1
        checknode(id, node, tree) ||
            error("Can't create new node $id")
    end
    getnodes(tree)[id] = node
    # Return the updated tree
    return id
end

function addnode!{N <: AbstractNode,
                  NI <: AbstractNodeInfo,
                  BI <: AbstractBranchInfo}(tree::ParameterisedTree{N, NI, BI};
                                            id::Int = 0)
    node = N()
    if (id > 0)
        checknode(id, node, tree) ||
            error("Can't create known node $id")
    else
        # Find highest node index
        if isempty(getnodes(tree))
            max_node = 0
        else
            max_node = maximum(keys(getnodes(tree)))
        end
        
        # Add the new node
        id = max_node + 1
        checknode(id, node, tree) ||
            error("Can't create new node $id")
    end
    getnodes(tree)[id] = node
    if !checknodeinfo(id, getnodeinfo(tree))
        getnodeinfo(tree)[id] = NI()
    end
    # Return the updated tree
    return id
end

function addnode!{N <: AbstractNode,
                  NI <: AbstractNodeInfo,
                  BI <: AbstractBranchInfo}(tree::ParameterisedTree{N, NI, BI}, label)
    if !haslabel(getnodeinfo(tree), label)
        error("Label $label is not found in $NI Dict")
    end
    return addnode!(tree, id = getid(getnodeinfo(tree), label))
end

"""
    addnodes!(tree::AbstractTree,
              nodes::Int)

Adds multiple `Node`s to a `Tree`
"""
function addnodes!(tree::AbstractTree,
                   nodes::Int)
    return map(_ -> addnode!(tree), 1:nodes)
end


"""
    deletenode!(tree::AbstractTree,
                nodes::Int)

Deletes a specified `Node` from a `Tree`
"""
function deletenode!(tree::AbstractTree,
                     node::Int)
    # Check if node exists
    if !haskey(getnodes(tree), node)
        error("Node does not exist")
        # Check if any branches are connected to node
    elseif hasinbound(tree, node) || countoutbounds(tree, node) > 0
        error("There are currently branches connected to this node")
    end
    # Remove node itself
    delete!(getnodes(tree), node)
    return tree
end


"""
    addbranch!(tree::AbstractTree,
               source::Int,
               target::Int,
               branch_length::Float64; id::Int = 0)

Adds a `Branch` of specified length to a `Tree`
"""
function addbranch!(tree::SimpleTree,
                    source::Int,
                    target::Int,
                    branch_length::Float64; id::Int = 0)
    
    branch = Branch(source, target, branch_length)
    if (id > 0)
        checkbranch(id, branch, tree) ||
            error("Can't create known branch $id")
    else
        # Find highest branch index
        if isempty(getbranches(tree))
            max_branch = 0
        else
            max_branch = maximum(keys(getbranches(tree)))
        end
        
        # Add the new branch
        id = max_branch + 1
        checkbranch(id, branch, tree) ||
            error("Can't create new branch $id")
    end
    
    # Add the new branch
    getbranches(tree)[id] = branch
    
    # Update the associated source and target nodes
    addoutbound!(getnodes(tree)[source], id)
    setinbound!(getnodes(tree)[target], id)
    
    # Return updated tree
    return id
end

function addbranch!{N <: AbstractNode,
                    NI <: AbstractNodeInfo,
                    BI <: AbstractBranchInfo}(tree::ParameterisedTree{N, NI, BI},
                                              source::Int,
                                              target::Int,
                                              branch_length::Float64,
                                              label)
    
    if !haslabel(getbranchinfo(tree), label)
        error("Label $label is not found in $BI Dict")
    end
    
    return addbranch!(tree, source, target, id = getid(getbranchinfo(tree), label))
end

"""
    branch!(tree::AbstractTree,
            source::Int,
            branch_length::Float64)

Adds a `Branch` of a specified length, and a `Node` to a `Tree`
"""
function branch!(tree::AbstractTree,
                 source::Int,
                 branch_length::Float64)
    target = addnode!(tree)
    try
        addbranch!(tree, source, target, branch_length)
    catch
        deletenode!(tree, target)
        rethrow()
    end
    return target
end

"""
    changesource!(tree::AbstractTree,
                  branch::Int,
                  new_source::Int)

Change the source `Node` of a `Branch`
"""
function changesource!(tree::AbstractTree,
                       branch::Int,
                       new_source::Int)
    # Error checking
    if !haskey(getbranches(tree), branch)
        error("Branch does not exist")
    elseif !haskey(getnodes(tree), newsource)
        error("New source node does not exist")
    elseif new_source == gettarget(tree, branch)
        error("Branch must connect unique nodes")
    end
    # Identify old source node
    old_source = getsource(tree, branch)
    # Remove branch reference from old source node
    deleteoutbound!(getnodes(tree)[old_source], branch)
    # Update new source node with branch reference
    setoutbound!(getnodes(tree, new_source), branch)
    # Update branch with new source node reference
    setsource!(getbranches(tree, branch), new_source)
    # Return updated tree
    return tree
end

"""
    changetarget!(tree::AbstractTree,
                  branch::Int,
                  new_target::Int)

Change the source `Node` of a `Branch`
"""
function changetarget!(tree::AbstractTree,
                       branch::Int,
                       new_target::Int)
    if !haskey(getbranches(tree), branch)
        error("Branch does not exist")
    elseif !haskey(getnodes(tree), new_target)
        error("New target node does not exist")
    elseif hasinbound(tree, new_target)
        error("New target node has an in degree > 1")
    end
    # Identify old target node
    old_target = gettarget(tree, branch)
    # Remove branch reference from old target node
    deleteinbound!(getnodes(tree)[old_target], branch)
    # Add branch reference to new target node
    setinbound!(getnodes(tree, new_target), branch)
    # Update branch with new target node reference
    settarget!(getbranches(tree, branch), new_target)
    # Return updated tree
    return tree
end

"""
    deletebranch!(tree::AbstractTree,
                  branch::Int)

    Delete a `Branch` from a `Tree`
    """
function deletebranch!(tree::AbstractTree,
                       branch::Int)
    if !haskey(tree.branches, branch)
        error("Branch does not exist")
    end
    # Identify old source node
    old_source = getsource(tree, branch)
    # Identify old target node
    old_target = gettarget(tree, branch)
    # Remove branch reference from its source node
    deleteoutbound!(getnodes(tree)[old_source], branch)
    # Remove branch reference from its target node
    deleteinbound!(getnodes(tree)[old_target], branch)
    # Remove branch itself
    delete!(getbranches(tree), branch)
    # Return the updated tree
    return tree
end
