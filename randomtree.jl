using PhyloTrees, Plots, StatsBase

g = Tree()
addnode!(g)
for i = 1:100
  branch!(g, sample(collect(keys(g.nodes))), 10*rand())
end
plot(g, dpi=200)
png(joinpath(@__DIR__, "treeplot.png"))