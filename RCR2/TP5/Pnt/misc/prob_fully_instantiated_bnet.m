function p = prob_fully_instantiated_bnet(bnet, inst)
% PROB_FULLY_INSTANTIATED_BNET Evaluate the probability assigned by the network to a case.
% p = prob_fully_instantiated_bnet(bnet, inst)
% inst{i} contains the value of node i, which may be a scalar or vector

p = 1;
for i=1:length(bnet.dag)
  fam = family(bnet.dag, i);
  e = bnet.equiv_class(i);
  p = p * evaluate_CPD(bnet.CPD{e}, fam, bnet.node_sizes, bnet.cnodes, inst);
end
