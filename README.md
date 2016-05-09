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

## Basic usage
A demo of the functionality of `PhyloTrees.jl` can be found [here](https://github.com/jangevaare/PhyloTrees.jl/blob/master/PhyloTreesDemo.ipynb).

## Plotting
Plotting of phylogenetic trees requires the `PyPlot.jl` package to be loaded. An example is shown in the [demo](https://github.com/jangevaare/PhyloTrees.jl/blob/master/PhyloTreesDemo.ipynb).
