function spr(tree::Tree)
  subtreeroot = sample(findnonroots(tree))
  subtreenodes = [subtreeroot; descendantnodes(tree, subtreeroot)]
  sampleorder = sample(1:length(tree.nodes), length(tree.nodes))
  for i in sampleorder
    if !(i in subtreenodes)
      reattachmentnode = i
      break
    end
  end
  return changesource!(copy(tree), tree.nodes[subtreeroot].in, reattachmentnode)
end
