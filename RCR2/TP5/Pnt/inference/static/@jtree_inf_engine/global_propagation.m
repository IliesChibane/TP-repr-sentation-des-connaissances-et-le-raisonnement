function [engine] = global_propagation(engine, evidence)
% ENTER_EVIDENCE Add the specified evidence to the network (jtree)
% [engine] = enter_evidence(engine, evidence)
% evidence{i} = [] if if X(i) is hidden, and otherwise contains its observed value (scalar or column vector)

pnet = pnet_from_engine(engine);
ns = pnet.node_sizes(:);
onodes = find(~isemptycell(evidence));

% Evaluate CPDs with evidence, and convert to potentials
N = length(pnet.dag);
CPDpot = cell(1,N);
for n=1:N
  fam = family(pnet.dag, n);
  e = pnet.equiv_class(n);
  CPDpot{n} = CPD_to_dpot(pnet.CPD{e}, fam, ns, evidence);
end
  
[clpot] = enter_soft_evidence(engine, CPDpot, onodes);
engine.clpot = clpot; % save the results for marginal_nodes

