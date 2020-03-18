# PhyloTrees.jl
[![Latest Release](https://img.shields.io/github/release/jangevaare/PhyloTrees.jl.svg)](https://github.com/jangevaare/PhyloTrees.jl/releases/latest)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/jangevaare/PhyloTrees.jl/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/jangevaare/PhyloTrees.jl.svg?branch=master)](https://travis-ci.org/jangevaare/PhyloTrees.jl)
[![codecov.io](http://codecov.io/github/jangevaare/PhyloTrees.jl/coverage.svg?branch=master)](http://codecov.io/github/jangevaare/PhyloTrees.jl?branch=master)

## Introduction

The objective of `PhyloTrees.jl` is to provide fast and simple tools for working with rooted phylogenetic trees in [Julia](http://julialang.org).

## Installation

The current release can be installed from the Julia REPL with:

```julia
pkg> add PhyloTrees
```

The development version (master branch) can be installed with:

```julia
pkg> add PhyloTrees#master
```

## Usage

There are several ways to add nodes and branches to our `Tree`, see below for examples

    > # Initialize the tree
    > exampletree = Tree()

    Phylogenetic tree with 0 nodes and 0 branches

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

There are many other functions available that are helpful when dealing with trees including:
`changesource!`,
`changetarget!`,
`indegree`,
`outdegree`,
`isroot`,
`isleaf`,
`isinternal`,
`findroots`,
`findleaves`,
`findinternal`,
`findnonroots`,
`findnonleaves`,
`findexternal`,
`areconnected`,
`nodepath`,
`branchpath`,
`parentnode`,
`childnodes`,
`descendantcount`,
`descendantnodes`,
`ancestorcount`,
`ancestornodes`, and
`nodetype`.
