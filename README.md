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

    > # Initialize the tree
    > exampletree = Tree()

    Phylogenetic tree with 0 nodes and 0 branches

### The basics
There are several ways to add nodes and branches to our `Tree`, see below for examples

    > # Add a node to the tree
    > addnode!(exampletree)

    Phylogenetic tree with 1 nodes and 0 branches

Branches have `Float64` lengths

    > # Add a node, connect it to node 1 with a branch 5.0 units in length
    > branch!(exampletree, 1, 5.0)

    Phylogenetic tree with 2 nodes and 1 branches

    > # Add 2 nodes
    > addnodes!(exampletree, 2)

    Phylogenetic tree with 4 nodes and 1 branches

    > # Add a branch from node 2 to node 3 10.0 units in length
    > addbranch!(exampletree, 2, 3, 10.0)

    Phylogenetic tree with 4 nodes and 2 branches

We can quickly look at the nodes present in our `Tree`:

    > collect(exampletree.nodes)
    
    [unattached node]
    [branch 1]-->[internal node]-->[branch 2]
    [branch 2]-->[leaf node]                 
    [root node]-->[branch 1]

### Other capabilities

Distance between nodes can be calculated using the `distance` function. A node visit ordering for postorder traversal of a tree can be found with `postorder`.

Trees can be plotted using `plot`.

There are many other functions available that are helpful when dealing with trees including:
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
`nodetype`
