function pot = CPD_to_cpot(CPD, domain, ns, cnodes, evidence)
% CPD_TO_CPOT Convert a CPD to a canonical Gaussian potential, incorporating any evidence (discrete)
% pot = CPD_to_cpot(CPD, domain, ns, cnodes, evidence)
%
% domain is the domain of CPD.
% node_sizes(i) is the size of node i.
% cnodes is all the continuous nodes
% evidence{i} is the evidence on the i'th node.
%
% Since we want the output to be a Gaussian, the whole family must be observed.
% In other words, the potential is really just a constant.

p = evaluate_CPD(CPD, domain, ns, cnodes, evidence);
ns(domain) = 0;
pot = cpot(domain, ns(domain), log(p));
