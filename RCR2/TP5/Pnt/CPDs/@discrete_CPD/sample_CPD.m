function x = sample_CPD(CPD, domain, ns, cnodes, evidence)
% SAMPLE_CPD Draw a random sample from a CPD given evidence on the parents (discrete)
% x = sample_CPD(CPD, domain, ns, cnodes, evidence)
%
% domain is the domain of CPD.
% node_sizes(i) is the size of node i.
% cnodes = all the cts nodes
% evidence{i} is the evidence on the i'th node.

ps = domain(1:end-1);
self = domain(end);
CPT = CPD_to_CPT(CPD);
if isempty(ps)
  T = CPT;
else
  assert(~any(isemptycell(evidence(ps))));
  pvals = cat(1, evidence{ps});
  i = subv2ind(ns(ps), pvals(:)');
  T = reshape(CPT, [prod(ns(ps)) ns(self)]);
  T = T(i,:);
end
x = sample_discrete(T);
