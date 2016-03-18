# Phylogenetics.jl

[![Build Status](https://travis-ci.org/jangevaare/Phylogenetics.jl.svg?branch=master)](https://travis-ci.org/jangevaare/Phylogenetics.jl)

Phylogenetics.jl has two main objectives. The first objective is to provide a simple, fast, and flexible method of simulating genetic sequence data from a specified phylogenetic tree and substitution model. The second is to perform efficient likelihood calculations of phylogenetic trees with native Julia code.

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
