function p = evaluate_CPD(CPD, domain, ns, cnodes, evidence)
% EVALUATE_CPD Compute the probability of a fully instantiated CPD (discrete)
% p = evaluate_CPD(CPD, domain, cnodes, evidence)

assert(~any(isemptycell(evidence(domain))));
vals = cat(1, evidence{domain});
CPT = CPD_to_CPT(CPD);
index = subv2ind(mysize(CPT), vals(:)');
p = CPT(index);
