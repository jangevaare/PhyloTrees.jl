using Phylogenetics
using Base.Test

# write your own tests here
@test 1 == 1

using Phylogenetics
a = Tree()
add_node!(a, 1000)
add_node!(a, 1000)
add_node!(a, 1000)
add_node!(a, 1000)
add_branch!(a, 1.0, 1, 2)
add_branch!(a, 1.0, 1, 3)
add_branch!(a, 1.0, 3, 4)

simulate!(a, JC69([1.0e-5]))
