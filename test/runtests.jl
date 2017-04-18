module TestPhylo

using PhyloTrees
using Base.Test

@testset "Tree()" begin
    g = Tree()
    n = addnode!(g)
    n2 = branch!(g, n, 10.0)
    n3 = branch!(g, n, 5.0)
    n4 = branch!(g, n2, 20.0)
    n5 = branch!(g, n2, 3.5)

    @test length(findroots(g)) == 1
    @test length(findleaves(g)) == 3
    @test length(findnodes(g)) == 1

    for i in 1:length(g.nodes)
        @test outdegree(g, i) <= 2
        @test indegree(g, i) <= 1
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
    @test verify(g)
end

@testset "NamedTree()" begin
    nt = NamedTree(["Dog", "Cat", "Human"])
    @test verify(nt)
    n = addnode!(nt)
    @test !verify(nt)
    addbranch!(nt, n, "Dog", 2.0)
    addbranch!(nt, n, "Cat", 2.0)
    @test_throws ErrorException addbranch!(nt, n, "Human", 2.0)
    @test verify(nt)
    r = addnode!(nt)
    @test_throws ErrorException addbranch!(nt, r, "Potato", 2.0)
    @test !verify(nt)
    addbranch!(nt, r, "Human", 5.0)
    addbranch!(nt, r, n, 3.0)
    @test maximum(distance(nt)) ≈ 10.0
    @test verify(nt)
end

end
