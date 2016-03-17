using Phylogenetics
using Base.Test

# 1.0 Substitution models
# 1.1 JC69
a = JC69()
@test maximum(abs(expm(Q(a)) .- P((a), 1.0))) < 1e-15
@test P((a), Inf)[:,1] == a.π

# 1.2 K80
@test Q(K80([1. 1.])) == Q(JC69())
b = K80([1. 2.])
@test maximum(abs(expm(Q(b)) .- P((b), 1.0))) < 1e-15
@test P((b), Inf)[:,1] == b.π

# 1.3 F81

# 1.4 F84

# 1.5 HKY85

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
