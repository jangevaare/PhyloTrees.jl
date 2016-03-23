# PhyloTrees.jl

[![Build Status](https://travis-ci.org/jangevaare/PhyloTrees.jl.svg?branch=master)](https://travis-ci.org/jangevaare/PhyloTrees.jl)

## Introduction

PhyloTrees.jl has two main objectives. The first objective is to provide a simple, fast, and flexible method of simulating genetic sequence data from a specified phylogenetic tree and substitution model. The second is to perform efficient likelihood calculations of phylogenetic trees with native [Julia language](http://julialang.org) code.

Currently the following substitution models are supported by Phylogenetics.jl:
* JC69
* K80
* F81
* F84
* HKY85
* TN93
* GTR
* UNREST

These substitution models may be utilized in conjunction with rate variation amongst nucleotide sites or branches of the phylogenetic tree.

## Installation
    Pkg.update()
    Pkg.add("PhyloTrees")

## Basic usage
Use the PhyloTrees.jl package

    using PhyloTrees

Create a tree with a specified sequence length

    tree1 = Tree(1000)

Add nodes to the tree

    add_node!(tree1)
    add_node!(tree1)
    add_node!(tree1)
    add_node!(tree1)

Add branches to the tree, of a specified length, from a source node to a target node.

    add_branch!(tree1, 10.0, 1, 2)
    add_branch!(tree1, 10.0, 1, 3)
    add_branch!(tree1, 10.0, 3, 4)

Simulate sequence data for a specified phylogenetic tree, using a parametrized substitution model

    simulate!(tree1, JC69([1.0e-5]))
