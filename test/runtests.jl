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
