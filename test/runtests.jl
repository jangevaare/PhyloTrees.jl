using PhyloTrees
using Test

g = Tree()
addnode!(g)
branch!(g, 1, 10.0)
branch!(g, 1, 5.0)
branch!(g, 2, 20.0)

@test length(findroots(g)) == 1
@test length(findleaves(g)) - 1 == length(findinternals(g))

for i = 1:length(g.nodes)
  @test length(g.nodes[i].out) <= 2
  @test length(g.nodes[i].in) <= 1
end

@test areconnected(g, 1, 2)
@test nodepath(g, 1, 2) == [1, 2]
@test branchpath(g, 1, 2) == [1]
@test distance(g, 1, 2) == 10.0
@test distance(g, 1, 4) == 30.0
@test distance(g, 4, 3) == 35.0

@test sum(distance(g)) > 0.

@test_nowarn PhyloTrees._treeplot(g)

@testset "Postorder traversal" begin
  @test isempty(postorder(Tree()))
  forest = Tree()
  for id in (10, 20, 30, 40, 50, 60)
    forest.nodes[id] = PhyloTrees.Node()
  end
  addbranch!(forest, 10, 20, 1.0)
  addbranch!(forest, 10, 30, 1.0)
  addbranch!(forest, 40, 50, 1.0)
  order = postorder(forest)
  @test Set(order) == Set(keys(forest.nodes))
  @test length(order) == length(forest.nodes)
  positions = Dict(node => i for (i, node) in enumerate(order))
  @test all(positions[b.target] < positions[b.source] for b in values(forest.branches))
  # Deep trees must not depend on the language call stack.
  chain = Tree()
  for id in 1:10000
    chain.nodes[id] = PhyloTrees.Node()
    if id > 1
      chain.branches[id-1] = PhyloTrees.Branch(id-1, id, 1.0)
      push!(chain.nodes[id-1].out, id-1)
      push!(chain.nodes[id].in, id-1)
    end
  end
  @test postorder(chain) == collect(10000:-1:1)
  addbranch!(forest, 20, 10, 1.0)
  @test_throws ArgumentError postorder(forest)
end
