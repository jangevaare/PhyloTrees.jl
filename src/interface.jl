using Compat

@compat abstract type AbstractNode end
@compat abstract type AbstractInfo end
@compat abstract type AbstractTree{NodeLabel, BranchLabel} end

# Interfaces to an AbstractTree
# -----------------------------
#
# These must be implemented for each AbstractTree subtype:
#  - _getnodes()
#  - _getbranches()
#  - _addnode!()
#
# These may be implemented (default implementations exist):
#  - _hasnode()
_hasnode(tree::AbstractTree, label) = haskey(getnodes(tree), label)
#  - _hasbranch()
_hasbranch(tree::AbstractTree, label) = haskey(getbranches(tree), label)
#  - _addnodes!()
_addnodes!(tree::AbstractTree, count::Int) = map(_ -> addnode!(tree), 1:count)
_addnodes!(tree::AbstractTree, nodes::AbstractVector) =
    map(node -> addnode!(tree, node), nodes)
#  - _addbranch!()
function _addbranch!(tree::AbstractTree, source, target,
                     length::Float64, label)
    # Add the new branch
    setbranch!(tree, label, Branch(source, target, length))
    
    # Update the associated source and target nodes
    _addoutbound!(getnode(tree, source), label)
    _setinbound!(getnode(tree, target), label)
    
    # Return updated tree
    return label
end
#  - _deletenode!()
function _deletenode!(tree::AbstractTree, label)
    node = getnode(tree, label)
    if _hasinbound(node)
        deletebranch!(tree, _getinbound(node))
    end
    for b in _getoutbounds(node)
        deletebranch!(tree, b)
    end
    delete!(_getnodes(tree), label)
    return label
end
#  - _deletebranch!()
function _deletebranch!(tree::AbstractTree, label)
    # Find the branch
    branch = getbranch(tree, label)
    # Remove branch reference from its source node
    deleteoutbound!(_getsource(branch), label)
    # Remove branch reference from its target node
    deleteinbound!(_gettarget(branch), label)
    # Remove branch itself
    delete!(_getbranches(tree), branch)
    # Return the branch label
    return label
end
#  - _branch!()
function _branch!(tree::AbstractTree, source, length::Float64)
    target = addnode!(tree)
    try
        addbranch!(tree, source, target, length)
    catch
        deletenode!(tree, target)
        rethrow()
    end
    return target
end
#  - _getleafrecords()
function _getleafrecords(tree::AbstractTree)
    return Dict(map(leaf -> leaf=>nothing,
                    findleaves(tree) ∪ findunattacheds(tree)))
end
#  - _getleafnames()
function _getleafnames(tree::AbstractTree)
    return keys(Dict(map(leaf -> leaf=>nothing,
                         findleaves(tree) ∪ findunattacheds(tree))))
end
#  - _getleafrecord()
function _getleafrecord(tree::AbstractTree, label)
    return _getleafrecords(tree)[label]
end
#  - _setleafrecord()
function _setleafrecord!(tree::AbstractTree, label, value)
    _getleafrecords(tree)[label] = value
    return value
end
#  - _getnoderecords()
function _getnoderecords(tree::AbstractTree)
    return Dict(map(node -> node=>nothing, keys(getnodes(tree))))
end
#  - _getnoderecord()
function _getnoderecord(tree::AbstractTree, label)
    return _getnoderecords(tree)[label]
end
#  - _setnoderecord!()
function _setnoderecord!(tree::AbstractTree, label, value)
    _getnoderecords(tree)[label] = value
    return value
end
#  - _verify()
function _verify(tree::AbstractTree)
    return true
end
#  - _newnodelabel() - implemented for integer labels
function _newnodelabel{NL <: Integer, BL}(tree::AbstractTree{NL, BL})
    nodes = getnodes(tree)
    return isempty(nodes) ? 1 : maximum(keys(nodes)) + 1
end
function _newnodelabel{BL}(tree::AbstractTree{String, BL})
    nodes = getnodes(tree)
    names = Compat.Iterators.filter(n -> length(n) > 5 && n[1:5]=="Node ", keys(nodes))
    start = 1
    name = "Node $start"
    while (name ∈ names)
        start += 1
        name = "Node $start"
    end
    return name
end
#  - _newbranchlabel() - implemented for integer labels
function _newbranchlabel{NL, BL <: Integer}(tree::AbstractTree{NL, BL})
    branches = getbranches(tree)
    return isempty(branches) ? 1 : maximum(keys(branches)) + 1
end
function _newbranchlabel{NL}(tree::AbstractTree{NL, String})
    branches = getbranches(tree)
    names = Compat.Iterators.filter(n -> length(n) > 5 && n[1:5]=="Branch ", keys(branches))
    start = 1
    name = "Branch $start"
    while (name ∉ names)
        start += 1
        name = "Branch $start"
    end
    return name
end
#  - _hasheight()
function _hasheight(::AbstractInfo)
    return false
end
function _hasheight(::Void)
    return false
end
#  - _getheight() - should never be called as hasheight returns false
function _getheight(::AbstractInfo)
    throw(NullException())
    return NaN
end
function _getheight(::Void)
    throw(NullException())
    return NaN
end
#  - _setheight!() - ignore set value
function _setheight!(::AbstractInfo, value::Float64)
    warn("Ignoring height")
    return value
end
function _setheight!(::Void, value::Float64)
    warn("Ignoring height")
    return value
end
#  - _hasrootheight()
function _hasrootheight(tree::AbstractTree)
    return false
end
#  - _getrootheight() - should never be called as hasrootheight returns false
function _getrootheight(tree::AbstractTree)
    throw(NullException())
    return NaN
end
#  - _setrootheight!() - ignore set value
function _setrootheight!(tree::AbstractTree, value::Float64)
    warn("Ignoring root height")
    return value
end

#  - _clearrootheight!() - ignore
function _clearrootheight!(tree::AbstractTree)
end

# Interfaces to an AbstractNode
# -----------------------------
#
# These must be implemented for each AbstractNode subtype:
#  - _hasinbound()
#  - _outdegree()
#  - _hasoutboundspace()
#  - _getinbound()
#  - _setinbound!()
#  - _deleteinbound!()
#  - _getoutbounds()
#  - _addoutbound!()
#  - _deleteoutbound!()
#
# These may be implemented (default implementations exist):
#  - _indegree()
_indegree(node::AbstractNode) = _hasinbound(node) ? 1 : 0
#  - _isroot()
_isroot(node::AbstractNode) = !_hasinbound(node) && _outdegree(node) > 0
#  - _isleaf()
_isleaf(node::AbstractNode) = _outdegree(node) == 0 && _hasinbound(node)
#  - _isinternal()
_isinternal(node::AbstractNode) = _outdegree(node) > 0 && _hasinbound(node)
#  - _isunattached()
_isunattached(node::AbstractNode) = _outdegree(node) == 0 && !_hasinbound(node)

# Interfaces to a Branch
# ----------------------
#
# These must be implemented for Branch:
#  - _getsource()
#  - _gettarget()
#  - _getlength()
#  - _setsource!()
#  - _settarget!()

# Interfaces to an AbstractInfo
# -----------------------------
#
# These must be implemented by each AbstractInfo subtype:
#  - _getheight()
#  - _setheight!()
#  - _hasheight()

# Interfaces to a tree
# --------------------
"""
    getnodes(::AbstractTree)

retrieve the Dict containing the nodes of the tree.
"""
function getnodes(tree::AbstractTree)
    return _getnodes(tree)
end

"""
    getbranches(::AbstractTree)

retrieve the Dict containing the branches of the tree.
"""
function getbranches(tree::AbstractTree)
    return _getbranches(tree)
end

"""
    getleafnames(::AbstractTree)

retrieve the leaf names from the tree.
"""
function getleafnames(tree::AbstractTree)
    return collect(_getleafnames(tree))
end

"""
    getleafrecords(::AbstractTree)

retrieve the Dict containing the leaf records of the tree.
"""
function getleafrecords(tree::AbstractTree)
    return _getleafrecords(tree)
end

"""
    getleafrecord(::AbstractTree, label)

retrieve the leaf record for a leaf of the tree.
"""
function getleafrecord(tree::AbstractTree, label)
    return _getleafrecord(tree, label)
end

"""
    setleafrecord(::AbstractTree, label, value)

Set the leaf record for a leaf of the tree.
"""
function setleafrecord!(tree::AbstractTree, label, value)
    return _setleafrecord!(tree, label, value)
end

"""
    getnoderecords(::AbstractTree)

retrieve the Dict containing the node records of the tree.
"""
function getnoderecords(tree::AbstractTree)
    return _getnoderecords(tree)
end

"""
    getnoderecord(::AbstractTree, label)

retrieve the node record for a leaf of the tree.
"""
function getnoderecord(tree::AbstractTree, label)
    return _getnoderecord(tree, label)
end

"""
    setnoderecord(::AbstractTree, label, value)

Set the node record for a node of the tree.
"""
function setnoderecord!(tree::AbstractTree, label, value)
    return _setnoderecord!(tree, label, value)
end

"""
    hasrootheight(::AbstractTree)

Returns whether the tree has a root height record.
"""
function hasrootheight(tree::AbstractTree)
    return _hasrootheight(tree)
end

"""
    getrootheight(::AbstractTree)

Returns  the tree's root height record.
"""
function getrootheight(tree::AbstractTree)
    return _getrootheight(tree)
end

"""
    setrootheight!(::AbstractTree, ::Float64)

Sets the tree's root height record.
"""
function setrootheight!(tree::AbstractTree, height::Float64)
    return _setrootheight!(tree, height)
end

"""
    clearrootheight(::AbstractTree)

Clears the tree's root height record.
"""
function clearrootheight!(tree::AbstractTree)
    _clearrootheight!(tree, height)
end

"""
    verify(::AbstractTree)

Return whether the tree is valid.
"""
function verify{NL, BL}(tree::AbstractTree{NL, BL})
    nodes = getnodes(tree)
    branches = getbranches(tree)
    if !isempty(nodes) || !isempty(branches)
        # We need to validate the connections
        if Set(mapreduce(_getinbound, push!, BL[],
                         Compat.Iterators.filter(_hasinbound, values(nodes)))) !=
                             Set(keys(branches))
            warn("Inbound branches must exactly match Branch labels")
            return false
        end
        
        if Set(mapreduce(_getoutbounds, append!, BL[], values(nodes))) !=
            Set(keys(branches))
            warn("Node outbound branches must exactly match Branch labels")
            return false
        end
        
        if !(mapreduce(_getsource, push!, NL[], values(branches)) ⊆
             Set(keys(nodes)))
            warn("Branch sources must be node labels")
            return false
        end

        if !(mapreduce(_gettarget, push!, NL[], values(branches)) ⊆
             Set(keys(nodes)))
            warn("Branch targets must be node labels")
            return false
        end

        if length(findroots(tree) ∪ findunattacheds(tree)) == 0
            warn("This tree has no roots")
            return false
        end

        if length(findleaves(tree) ∪ findunattacheds(tree)) == 0
            warn("This tree has no leaves")
            return false
        end
    end
    
    return _verify(tree)
end


"""
    hasnode(tree::AbstractTree, label)

retrieve whether a specific node `label` of tree `tree` exists.
"""
function hasnode(tree::AbstractTree, label)
    return _hasnode(tree, label)
end

"""
    getnode(tree::AbstractTree, label)

retrieve a specific node `label` of tree `tree`.
"""
function getnode(tree::AbstractTree, label)
    _hasnode(tree, label) ||
        error("Node $label does not exist")
    return getnodes(tree)[label]
end

"""
    hasbranch(tree::AbstractTree, label)

retrieve whether a specific branch `label` of tree `tree` exists.
"""
function hasbranch(tree::AbstractTree, label)
    return _hasbranch(tree, label)
end

"""
    getbranch(tree::AbstractTree, label)

retrieve a specific branch `label` of tree `tree`.
"""
function getbranch(tree::AbstractTree, label)
    _hasbranch(tree, label) ||
        error("Branch $label does not exist")
    return getbranches(tree)[label]
end

"""
    setnode(tree::AbstractTree, label, node)

Set Node `node` to `label` in tree `tree`.
"""
function setnode!(tree::AbstractTree, label, node)
    _hasnode(tree, label) &&
        error("Node $label already exists")
    return getnodes(tree)[label] = node
end

"""
    setbranch(tree::AbstractTree, label, branch)

Set Branch `branch` to `label` in tree `tree`.
"""
function setbranch!(tree::AbstractTree, label, branch)
    _hasbranch(tree, label) &&
        error("Branch $label already exists")
    return getbranches(tree)[label] = branch
end

"""
    addnodes!(::AbstractTree, ...)

Add `count` nodes to the tree, or a specific vector of node `labels` to create.
"""
function addnodes! end

function addnodes!(tree::AbstractTree, nodes)
    return _addnodes!(tree, nodes)
end

"""
    addnode!(tree::AbstractTree[, label])

Add a node with an optional name `label` to the tree `tree`.
"""
function addnode!(tree::AbstractTree, label = _newnodelabel(tree))
    _hasnode(tree, label) &&
        error("Tree already has a node called $label")
    return _addnode!(tree, label)
end

"""
    deletenode!(tree::AbstractTree, label)

Delete a node with name `label` from the tree `tree`.
"""
function deletenode!(tree::AbstractTree, label)
    _hasnode(tree, label) ||
        error("Tree does not have a node called $label")
    return _deletenode!(tree, label)
end

"""
    addbranch!(tree::AbstractTree, source, target, [,length [, label]])

Add a branch of length `length` with an optional name `label` to the tree.
"""
function addbranch!(tree::AbstractTree, source, target,
                    length::Float64 = NaN;
                    label = _newbranchlabel(tree))
    _hasnode(tree, source) && hasoutboundspace(tree, source) ||
        error("Tree does not have an available source node called $label")
    _hasnode(tree, target) && !hasinbound(tree, target) ||
        error("Tree does not have an available target node called $label")
    _hasbranch(tree, label) &&
        error("Tree already has a branch called $label")
    return _addbranch!(tree, source, target, length, label)
end

"""
    deletebranch!(tree::AbstractTree, label)

Delete a node called `label` from the tree `tree`.
"""
function deletebranch!(tree::AbstractTree, label)
    _hasbranch(tree, label) ||
        error("Tree does not have a branch called $label")
    return _deletebranch!(tree, label)
end

"""
    branch!(tree::AbstractTree, source, length::Float64)

Branch from node `source`, creating a new node with a branch of length `length`.
"""
function branch!(tree::AbstractTree, source, length::Float64 = NaN)
    _hasnode(tree, source) ||
        error("Node $source not present in tree")
    hasoutboundspace(tree, source) ||
        error("Node $source has no space to add branches")
    return _branch!(tree, source, length)
end

# Interfaces to a node
# --------------------
"""
    indegree(tree::AbstractTree, label)

Determine indegree of node `label` in tree `tree`.
"""
function indegree(tree::AbstractTree, label)
    return _indegree(getnode(tree, label))
end

"""
    getinbound(tree::AbstractTree, label)

Get inbound connection of node `label`
"""
function getinbound(tree::AbstractTree, label)
    return _getinbound(getnode(tree, label))
end

"""
    setinbound!(tree::AbstractTree, label, inbound)

Set the inbound connection of node `label` to `inbound`
"""
function setinbound!(tree::AbstractTree, label, inbound)
    return _setinbound!(getnode(tree, label), inbound)
end

"""
    deleteinbound!(tree::AbstractTree, label[, inbound])

Delete the inbound connection (`inbound`) of node `label`
"""
function deleteinbound!(tree::AbstractTree, label,
                        inbound = getinbound!(tree, label))
    return _deleteinbound!(getnode(tree, label), inbound)
end

"""
    hasinbound(tree::AbstractTree, label)

Return whether node `label` has an inbound connection
"""
function hasinbound(tree::AbstractTree, label)
    return _hasinbound(getnode(tree, label))
end

"""
    hasinbound(tree::AbstractTree, label)

Return outdegree of node `label`
"""
function outdegree(tree::AbstractTree, label)
    return _outdegree(getnode(tree, label))
end

"""
    hasoutboundspace(tree::AbstractTree, label)

Return whether node `label` has room for another outbound connection
"""
function hasoutboundspace(tree::AbstractTree, label)
    return _hasoutboundspace(getnode(tree, label))
end

"""
    getoutbounds(tree::AbstractTree, label)

Get outbound connection(s) of node `label`
"""
function getoutbounds(tree::AbstractTree, label)
    return _getoutbounds(getnode(tree, label))
end

"""
    addoutbound!(tree::AbstractTree, label, outbound)

Add outbound connection `outbound` to node `label`
"""
function addoutbound!(tree::AbstractTree, label, outbound)
    return _addoutbound!(getnode(tree, label), outbound)
end

"""
    deleteoutbound!(tree::AbstractTree, label, outbound)

Delete outbound connection `outbound` from node `label`
"""
function deleteoutbound!(tree::AbstractTree, label, outbound)
    return _deleteoutbound!(getnode(tree, label), outbound)
end

"""
    isroot(tree::Tree, label)

Determine if node `label` is a root of the tree
"""
function isroot(tree::AbstractTree, label)
    return _isroot(getnode(tree, label))
end

"""
    isleaf(tree::AbstractTree, label)

Determine if node `label` is a leaf of the tree
"""
function isleaf(tree::AbstractTree, label)
    return _isleaf(getnode(tree, label))
end

"""
    isinternal(tree::AbstractTree, label)

Determine if node `label` is internal to the tree
"""
function isinternal(tree::AbstractTree, label)
    return _isinternal(getnode(tree, label))
end

"""
    isunattached(tree::AbstractTree, label)

Determine if node `label` is unattached to the tree
"""
function isunattached(tree::AbstractTree, label)
    return _isunattached(getnode(tree, label))
end

# Interfaces to a branch
# ----------------------
"""
    getsource(tree::AbstractTree, label)

Return source node of branch `label`
"""
function getsource(tree::AbstractTree, label)
    _getsource(getbranch(tree, label))
end

"""
    gettarget(tree::AbstractTree, label)

Return target node of branch `label`
"""
function gettarget(tree::AbstractTree, label)
    _gettarget(getbranch(tree, label))
end

"""
    getlength(tree::AbstractTree, label)

Return length of branch `label`
"""
function getlength(tree::AbstractTree, label)
    _getlength(getbranch(tree, label))
end

"""
    changesource!(tree::AbstractTree, label, source)

Change source node of branch `label` to `source`, adjusting
node records appropriately.
"""
function changesource!(tree::AbstractTree, label, source)
    _hasbranch(tree, label) ||
        error("Branch $label does not exist")
    _hasnode(tree, source) ||
        error("Node $source does not exist")
    branch = getbranch(tree, label)
    oldsource = _getsource(branch)
    _setsource!(branch, source)
    deleteoutbound!(tree, oldsource, label)
    addoutbound!(tree, source, label)
    return label
end

"""
    changetarget!(tree::AbstractTree, label, target)

Change target node of branch `label` to `target`, adjusting
node records appropriately.
"""
function changetarget!(tree::AbstractTree, label, target)
    _hasbranch(tree, label) ||
        error("Branch $label does not exist")
    _hasnode(tree, target) ||
        error("Node $target does not exist")
    branch = getbranch(tree, label)
    oldtarget = _gettarget(branch)
    _settarget!(branch, target)
    deleteinbound!(tree, oldtarget, label)
    setinbound!(tree, target, label)
    return label
end

# Interfaces to an info
# ---------------------

function hasheight(ai::AbstractInfo)
    return _hasheight(ai)
end

function getheight(ai::AbstractInfo)
    return _getheight(ai)
end

function setheight!(ai::AbstractInfo, height::Float64)
    return _setheight!(ai, height)
end

function hasheight(tree::AbstractTree, label)
    return _hasheight(getleafrecord(tree, label))
end

function getheight(tree::AbstractTree, label)
    return _getheight(getleafrecord(tree, label))
end

function setheight!(tree::AbstractTree, label, height::Float64)
    ai = getleafrecord(tree, label)
    _setheight!(ai, height)
    setleafrecord!(tree, label, ai)
    return height
end
