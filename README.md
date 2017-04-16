# PhyloTrees.jl

[![Build Status](https://travis-ci.org/jangevaare/PhyloTrees.jl.svg?branch=master)](https://travis-ci.org/jangevaare/PhyloTrees.jl)

## Introduction

The objective of `PhyloTrees.jl` is to provide simple, fast, and flexible tools for working with rooted phylogenetic trees in [Julia](http://julialang.org).

## Installation
    Pkg.add("PhyloTrees")

To enable plotting, install [Plots.jl](https://github.com/tbreloff/Plots.jl) and one of its [supported backends](http://plots.readthedocs.io/en/latest/backends/).

## Usage

There are several ways to add nodes and branches to our `Tree`, see below for examples

    > # Initialize the tree
    > exampletree = Tree()

    Phylogenetic tree with 0 nodes and 0 branches

    > # Add a node to the tree
    > addnode!(exampletree)

    1

Creating new nodes and branches alter the input tree, and return the
created node or branch id. Branches have `Float64` lengths:

    > # Add a node, connect it to node 1 with a branch 5.0 units in length
    > branch!(exampletree, 1, 5.0)

    2

    > # Add 2 nodes
    > addnodes!(exampletree, 2)

    2-element Array{Int64,1}:
     3
     4

    > # Add a branch from node 2 to node 3 10.0 units in length
    > addbranch!(exampletree, 2, 3, 10.0)

    2

We can quickly look at the nodes present in our `Tree`:

    > collect(getnodes(exampletree))
    4-element Array{Pair{Int64,PhyloTrees.Node},1}:
     [unattached node 4]
     [branch 1]-->[internal node 2]-->[branch 2]
     [branch 2]-->[leaf node 3]
     [root node 1]-->[branch 1]

### Other capabilities

Distance between nodes can be calculated using the `distance` function. A node visit ordering for postorder traversal of a tree can be found with `postorder`.

Trees can be plotted using `plot`.

There are many other functions available that are helpful when dealing with trees including:
`changesource!`,
`changetarget!`,
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
