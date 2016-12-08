# PhyloTrees.jl

[![Build Status](https://travis-ci.org/jangevaare/PhyloTrees.jl.svg?branch=master)](https://travis-ci.org/jangevaare/PhyloTrees.jl)

## Introduction

The objective of `PhyloTrees.jl` is to provide simple, fast, and flexible tools for working with rooted phylogenetic trees in [Julia](http://julialang.org).

## Installation
    Pkg.add("PhyloTrees")

To enable plotting, install [Plots.jl](https://github.com/tbreloff/Plots.jl) and one of its [supported backends](http://plots.readthedocs.io/en/latest/backends/).

## Usage

### Tree initialization
To initialize a `Tree`, you must declare the data type of each `Node` and `Branch`:

    > # Node data type
    > N = Float64
    >
    > # Branch data type
    > B = Void
    >
    > # Initialize the tree
    > exampletree = Tree{N, B}()

    Phylogenetic tree with 0 nodes and 0 branches

### The basics
There are several ways to add nodes and branches to our `Tree`, see below for examples

    > # Add a node to the tree
    > addnode!(exampletree)

    Phylogenetic tree with 1 nodes and 0 branches

    > # Add a node, connect it to node 1 with a branch
    > branch!(exampletree, 1)

    Phylogenetic tree with 2 nodes and 1 branches

    > # Add 2 nodes
    > addnodes!(exampletree, 2)

    Phylogenetic tree with 4 nodes and 1 branches

    > # Connect node 3 to node 2
    > addbranch!(exampletree, 2, 3)

    Phylogenetic tree with 4 nodes and 2 branches

### Nodes

We can quickly look at the nodes present in our `Tree`:

    > exampletree.nodes
    4-element Array{PhyloTrees.Node{Float64},1}:
    [root node]-->[branch 1]                                                               
    [branch 1]-->[internal node]-->[branch 2]
    [branch 2]-->[leaf node]                                                                    
We can label nodes:

    > # Set a label for node 1
    > setlabel!(exampletree.nodes[1], "Test label")
    [root node]-->[branch 1]

    > # Test if node 1 now has a label
    > haslabel(exampletree.nodes[1])
    true

    > # Get the label of node 1
    > getlabel(exampletree.nodes[1])
    "Test label"

    > # Create a labelled node
    > addnode!(exampletree, "Another test label")
    Phylogenetic tree with 5 nodes and 2 branches

Node data is contained in a `Nullable{N}` field named `data`:

    > node 1
    > exampletree.nodes[1].data
    Nullable{Float64}()

    > Get the data in node 1
    > getdata(exampletree.nodes[1])
    ERROR: NullException()     

### Branches

Branches have `Float64` lengths

    > # Add a branch of length 10.0 from node 2 to 4
    > addbranch!(exampletree, 2, 4, 10.0)
    Phylogenetic tree with 5 nodes and 3 branches

    > Retrieve the length of branch 3
    > exampletree.branches[3].length
    10.0

Branches are not labelled, but they do have a `Nullable{B}` field named `data`:

    > Get the data in branch 1
    > getdata(exampletree.branches[1])
    ERROR: NullException()

### Other capabilities

Distance between nodes can be calculated using the `distance` function. A node visit ordering for postorder traversal of a tree can be found with `postorder`.

Trees can be plotted using `plot`.

There are many other functions available that are helpful when dealing with trees including:
`addsubtree!`,
`subtree`,
`changesource!`,
`changetarget!`,
`validnode`,
`validnodes`,
`validbranch`,
`validbranches`,
`indegree`,
`outdegree`,
`isroot`,
`isleaf`,
`isnode`,
`findroots`,
`findleaves`,
`findnodes`,
`findnonroots`,
`findnonleaves`,
`findnonnodes`,
`areconnected`,
`nodepath`,
`branchpath`,
`parentnode`,
`childnodes`,
`descendantcount`,
`descendantnodes`,
`ancestorcount`,
`ancestornodes`, and
`nodetype`,
`haslabel`,
`setlabel!`,
`getlabel`,
`hasdata`,
`setdata!`,
`getdata`
