function seq = sample_dbn(bnet, T)
% SAMPLE_DBN Generate a random sequence from a DBN.
% SEQ = SAMPLE_DBN(BNET, T)
% SEQ{i,t} contains the values of the i'th node in the t'th slice.

ss = length(bnet.intra);
seq = cell(ss, T);

eclass = [bnet.equiv_class(:,1) repmat(bnet.equiv_class(:,2), [1 T-1])];
ns = repmat(bnet.node_sizes_slice(:), [1 T]);
cnodes = unroll_set(bnet.cnodes_slice, length(bnet.intra), T);

for t=1:T
  for i=1:ss
    fam = family(bnet.dag, i, t);
    j = fam(end);
    e = eclass(j);
    seq{i,t} = sample_CPD(bnet.CPD{e}, fam, ns(:), cnodes(:), seq);
  end
end
