function [clq_ass_to_cluster, mult_cluster_ndx, marg_cluster_ndx] = mk_cluster_clq_ndx(engine, ns, clusters, T)

cliques = cliques_from_engine(engine);
C = length(clusters);
clq_ass_to_cluster = zeros(C, T);
mult_cluster_ndx = cell(C,T);
marg_cluster_ndx = cell(C,T);
ss = length(ns);
ns = [ns(:) ns(:)];
ns = ns(:)';
for c=1:C
  for t=1:T
    k = clq_containing_nodes(engine, clusters{c}+(t-1)*ss);
    clq_ass_to_cluster(c,t) = k;
    mult_cluster_ndx{c,t} = mk_multiply_table_ndx(cliques{k}, clusters{c} + (t-1)*ss, ns);
    marg_cluster_ndx{c,t} = mk_marginalise_table_ndx(cliques{k}, clusters{c} + (t-1)*ss, ns);
  end
end
