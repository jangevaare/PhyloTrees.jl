using Distributions
branchdist = Uniform(0,10)

g = Tree()
addnode!(g)
for i = 1:200
  branch!(g, sample(collect(keys(g.nodes))), rand(branchdist))
end

plot(g)
