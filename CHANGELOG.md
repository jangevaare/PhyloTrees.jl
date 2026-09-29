# Changelog

This history was reconstructed from the commits and source changes between
successive tags. Changes after the latest tag are listed as unreleased, even
where the package version has already been updated.

## Unreleased (version set to 0.12.0)

- Make postorder traversal work efficiently for large trees, forests, isolated
  nodes, and sparse node IDs. Directed cycles now raise a clear error.
- Add `DistanceIndex` for repeated node-distance queries and use it to avoid
  duplicate work when building the leaf distance matrix.
- Remove the old `findroot` export; use `findroots` instead. Add logging and
  refresh Julia compatibility and CI workflows.

## [0.11.1](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.11.0...v0.11.1)

- Make tree plots reject infinite node heights with a clear error and keep
  leaf markers from becoming oversized.
- Improve the README tree example and remove the remaining checked-in manifest.

## [0.11.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.10.0...v0.11.0)

- Restore tree plotting through a RecipesBase recipe and show leaf labels on
  plots. Add `leafnodes` and `leafcount` helpers used by the plot.
- Update package compatibility, installation guidance, Julia 1.4 testing,
  code coverage, and release automation.

## [0.10.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.9.0...v0.10.0)

- Remove the plotting code and its package dependency to keep the core tree
  package smaller. Plotting returns in 0.11.0.
- Remove the checked-in root dependency manifest.

## [0.9.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.8.0...v0.9.0)

- Update the package for Julia 1.x, replacing deprecated traversal syntax.
- Move dependency declarations from `REQUIRE` to `Project.toml` and update
  the test setup.

## [0.8.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.7.0...v0.8.0)

- Add pairwise distances between leaves and more ways to measure a node's
  distance from its root.
- Add tree height and setters for height, branch length, and branch endpoints.
- Require Julia 0.6 and update the CI configuration.

## [0.7.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.6.1...v0.7.0)

- Rewrite tree construction and editing around a simpler node and branch
  structure. Add functions to delete nodes and branches.
- Simplify the public API by removing subtree extraction, validity-check
  helpers, and node label/data accessors.
- Update postorder traversal to handle dictionary-backed node IDs.

## [0.6.1](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.6.0...v0.6.1)

- Add helpers to set, get, and check node data, and add `findroot`.
- Improve tree and branch display, including branches without a length.
- Expand the README with tree construction and querying examples.

## [0.6.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.5.0...v0.6.0)

- Narrow PhyloTrees to tree structure, traversal, editing, and distance
  operations. Sequence simulation, substitution models, and likelihood or
  inference code move to PhyloModels.jl.
- Store nodes and branches by ID, making tree edits and access by ID more
  direct. Remove the Distributions dependency.

## [0.5.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.4.0...v0.5.0)

- Add a `Sequence` type and use it in simulation and tree likelihood
  calculations.
- Expand substitution-model priors and proposal functions, and improve how
  sequences and models are displayed.
- Replace nullable sequence values in simulation.

## [0.4.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.3.0...v0.4.0)

- Add tree likelihood calculation and subtree prune-and-regraft editing.
- Introduce branch and node construction helpers, substitution-model priors,
  and early MCMC types.
- Switch plotting to a RecipesBase recipe so users can choose a compatible
  plotting backend.

## [0.3.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.2.1...v0.3.0)

- Add tree plotting and plotting examples, with PyPlot loaded only when needed.
- Add more tree construction and path or distance helpers.
- Rename the substitution-model type to `SubstitutionModel`.

## [0.2.1](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.2.0...v0.2.1)

- Add relative-rate forms of the nucleotide substitution models.
- Improve display of trees and models, and add a demonstration notebook.

## [0.2.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.1.0...v0.2.0)

- Add subtree extraction and attachment, node and branch path helpers, and
  distances between nodes.
- Add likelihood calculation for a pair of sequences under a substitution
  model, plus tests for the new tree operations.

## [0.1.0](https://github.com/jangevaare/PhyloTrees.jl/compare/v0.0.1...v0.1.0)

- Rework tree types and construction, add a readable tree display, and
  document a basic simulation example.
- Remove the UNREST substitution model.

## [0.0.1](https://github.com/jangevaare/PhyloTrees.jl/tree/v0.0.1)

- Initial release of tree construction, traversal, and sequence simulation,
  with several nucleotide substitution models and early likelihood support.
