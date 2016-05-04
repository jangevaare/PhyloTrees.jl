"""
Produce a data frame for the purposes of plotting a `Tree`
"""
function plotdata(tree::Tree)
  nodes = findroots(tree)
  nodecount = [length(nodes)]
  if nodecount[1] > 1
    error("Multiple root nodes detected")
  end
  heights = [0.5]
  for i = 1:nodecount[end]
    append!(nodes, childnodes(tree, node[i]))
  end
  descendentcount = descendents(tree, nodes)
  distances = distance(tree, nodes)

  countpct = descendentcount[nodecount[end]+1:end]/sum(descendentcount[nodecount[end]+1:end])
  heightpct = cumsum(countpct) .- 0.5*countpct

# TAKING A BREAK HERE
end
