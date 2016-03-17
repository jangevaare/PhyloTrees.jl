using Phylogenetics
using Base.Test
using Distributions

# 1.0 Substitution models
# 1.1 JC69
t = rand(Gamma(10.))
a = JC69([1.])
@test maximum(abs(expm(Q(a) * t) .- P(a, t))) < 1e-14
@test P(a, Inf) * rand(Multinomial(1, [0.25, 0.25, 0.25, 0.25])) == a.π

# 1.2 K80
@test Q(K80([1., 1.])) == Q(a)
t = rand(Gamma(10.))
b = K80([1., 2.])
@test maximum(abs(expm(Q(b) * t) .- P(b, t))) < 1e-14
@test P(b, Inf) * rand(Multinomial(1, [0.25, 0.25, 0.25, 0.25])) == b.π

# 1.3 F81
@test Q(F81([4.], [0.25, 0.25, 0.25, 0.25])) == Q(a)
πc = rand(Dirichlet([0.25, 0.25, 0.25, 0.25]))
t = rand(Gamma(10.))
c = F81([1.], πc)
@test maximum(abs(expm(Q(c) * t) .- P(c, t))) < 1e-14
@test P(c, Inf) * rand(Multinomial(1, [0.25, 0.25, 0.25, 0.25])) == c.π

# 1.4 F84
πd = rand(Dirichlet([0.25, 0.25, 0.25, 0.25]))
t = rand(Gamma(10.))
d = F84([1., 2.], πd)
@test maximum(abs(expm(Q(d) * t) .- P(d, t))) < 1e-14
@test P(d, Inf) * rand(Multinomial(1, [0.25, 0.25, 0.25, 0.25])) == d.π

# 1.5 HKY85
πe = rand(Dirichlet([0.25, 0.25, 0.25, 0.25]))
t = rand(Gamma(10.))
e = HKY85([1., 2.], πe)
@test maximum(abs(expm(Q(e) * t) .- P(e, t))) < 1e-14
@test P(e, Inf) * rand(Multinomial(1, [0.25, 0.25, 0.25, 0.25])) == e.π

# 1.6 TN93

# 1.7 GTR

# 1.8 UNREST

# 2.0 Simulation
a = Tree(1000)
add_node!(a)
add_node!(a)
add_node!(a)
add_node!(a)
add_branch!(a, 10.0, 1, 2)
add_branch!(a, 10.0, 1, 3)
add_branch!(a, 10.0, 3, 4)

simulate!(a, JC69([1.0e-5]))

# 3.0 Inference
