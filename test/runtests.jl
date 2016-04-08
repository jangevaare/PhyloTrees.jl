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

# 1.8 UNREST

# 2.0 Tree generation
a = Tree()
branch!(a, 1, 10.0)
branch!(a, 1, 5.0)
branch!(a, 2, 20.0)

@test length(findroot(a)) == 1
@test length(findleaves(a)) - 1 == length(findnodes(a))

for i = 1:length(a.nodes)
  @test length(a.nodes[i].out) <= 2
  @test length(a.nodes[i].in) <= 1
end

# 3.0 Simulation
seq = simulate(a, JC69([1.0e-5]), 1000)

# 4.0 Inference
