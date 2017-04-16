module TestPhylo

using PhyloTrees
using Base.Test

g = SimpleTree()
n = addnode!(g)
n2 = branch!(g, n, 10.0)
n3 = branch!(g, n, 5.0)
n4 = branch!(g, n2, 20.0)
n5 = branch!(g, n2, 3.5)

@test length(findroots(g)) == 1
@test length(findleaves(g)) == 3
@test length(findnodes(g)) == 1

for i = 1:length(g.nodes)
    @test countoutbounds(g, i) <= 2
    @test length(getinbounds(g, i)) <= 1
end

@test nodepath(g, n, n2) == [1, 2]
@test branchpath(g, n, n2) == [1]
@test distance(g, n, n2) ≈ 10.0
@test distance(g, n, n4) ≈ 30.0
@test distance(g, n4, n3) ≈ 35.0

@test sum(distance(g)) > 0.0 

@test areconnected(g, n, n2)
@test areconnected(g, n3, n2)
nx = addnode!(g)
@test !areconnected(g, n3, nx)

end
