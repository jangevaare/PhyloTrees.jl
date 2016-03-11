using Phylogenetics
using Base.Test

# write your own tests here
@test 1 == 1

using Phylogenetics
a = Tree(1000)
add_node!(a)
add_node!(a)
add_node!(a)
add_node!(a)
add_branch!(a, 10.0, 1, 2)
add_branch!(a, 10.0, 1, 3)
add_branch!(a, 10.0, 3, 4)

simulate!(a, JC69([1.0e-5]))
