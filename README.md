# PhyloTrees.jl

[![Build Status](https://travis-ci.org/jangevaare/PhyloTrees.jl.svg?branch=master)](https://travis-ci.org/jangevaare/PhyloTrees.jl)

## Introduction

The objective of `PhyloTrees.jl` is to provide a simple, fast, and flexible method of simulating genetic sequence data from a specified phylogenetic tree and substitution model with native [Julia](http://julialang.org) code.

Currently the following substitution models are supported by `PhyloTrees.jl` (full and relative rate forms):
* JC69
* K80
* F81
* F84
* HKY85
* TN93
* GTR

These substitution models may be utilized in conjunction with heterogeneous site rates.

## Installation
    Pkg.add("PhyloTrees")

To enable plotting, install [Plots.jl](https://github.com/tbreloff/Plots.jl) and one of its [supported backends](http://plots.readthedocs.io/en/latest/backends/).

## Basic usage
A demo of the functionality of `PhyloTrees.jl` can be found [here](PhyloTreesDemo.ipynb).
