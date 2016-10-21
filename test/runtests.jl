using PhyloTrees
using Base.Test
using Distributions

# 1.0 Substitution models
# 1.1 JC69
ta = rand(Gamma(10.))
a = JC69([1.])
@test maximum(abs(expm(Q(a) * ta) .- P(a, ta))) < 1e-14
@test rand(Multinomial(1, a.π))' * P(a, Inf) == a.π'

# 1.2 K80
@test Q(K80([1., 1.])) == Q(a)
tb = rand(Gamma(10.))
b = K80([1., 2.])
@test maximum(abs(expm(Q(b) * tb) .- P(b, tb))) < 1e-14
@test rand(Multinomial(1, b.π))' * P(b, Inf) == b.π'

# 1.3 F81
@test Q(F81([4.], [0.25, 0.25, 0.25, 0.25])) == Q(a)
πc = [0.3, 0.3, 0.2, 0.2]
tc = rand(Gamma(10.))
c = F81([1.], πc)
@test maximum(abs(expm(Q(c) * tc) .- P(c, tc))) < 1e-14
@test rand(Multinomial(1, c.π))' * P(c, Inf) == c.π'

# 1.4 F84
πd = [0.3, 0.3, 0.2, 0.2]
td = rand(Gamma(10.))
d = F84([1., 2.], πd)
@test maximum(abs(expm(Q(d) * td) .- P(d, td))) < 1e-14
@test rand(Multinomial(1, d.π))' * P(d, Inf) == d.π'

# 1.5 HKY85
πe = [0.3, 0.3, 0.2, 0.2]
te = rand(Gamma(10.))
e = HKY85([1., 2.], πe)
@test maximum(abs(expm(Q(e) * te) .- P(e, te))) < 1e-14
@test rand(Multinomial(1, e.π))' * P(e, Inf) == e.π'

# 1.6 TN93
πf = [0.3, 0.3, 0.2, 0.2]
tf = rand(Gamma(10.))
f = TN93([1., 2., 3.], πf)
@test maximum(abs(expm(Q(f) * tf) .- P(f, tf))) < 1e-14
@test rand(Multinomial(1, f.π))' * P(f, Inf) == f.π'

# 1.7 GTR

# 2.0 Tree operations
# 2.1 Tree creation
g = Tree()
branch!(g, 1, 10.0)
branch!(g, 1, 5.0)
branch!(g, 2, 20.0)

@test length(findroots(g)) == 1
@test length(findleaves(g)) - 1 == length(findnodes(g))

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


# 2.2 Subtrees
@test findleaves(subtree(g, 1)) == findleaves(g)

# 2.3 Combining trees
@test 2*length(findroots(g)) == length(findroots(addsubtree!(g, subtree(g, 1))))

# 3.0 Simulation
g = Tree()
branch!(g, 1, 10.0)
branch!(g, 1, 5.0)
branch!(g, 2, 20.0)

seq = simulate(g, JC69([1.0e-5]), 1000)
@test length(seq) == 4
for i = 1:length(seq)
  @test length(seq[i]) == 1000
end

# 4.0 Inference
# 4.1 Log likelihood between two sequences
@test loglikelihood(seq[1], seq[2], 10.0, JC69([1.0e-5])) > loglikelihood(seq[1], seq[2], 1000.0, JC69([1.0e-5]))

# 4.2 Tree log likelihood
# TODO
