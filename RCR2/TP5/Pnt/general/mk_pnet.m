function pnet = mk_pnet(dag, node_sizes, nodes, eclass)
% MK_pnet Make a possibilistic network structure.
%


n = length(dag);
if nargin < 3, nodes = 1:n; end
if nargin < 4, eclass = 1:n; end

pnet.dag = dag;

pnet.node_sizes = node_sizes(:)';

pnet.nodes = nodes;

pnet.equiv_class = eclass;

pnet.CPD = cell(1,length(pnet.equiv_class));

directed = 1;

assert(acyclic(dag,directed));

if 0
pnet.root_bitv = sparse(1,n);
pnet.leaf_bitv = sparse(1,n);
for i=1:n
  ps = parents(dag, i);
  if isempty(ps)
    pnet.root_bitv(i) = 1;
  end
  cs = children(dag, i);
  if isempty(cs)
    pnet.leaf_bitv(i) = 1;
  end
end
end
