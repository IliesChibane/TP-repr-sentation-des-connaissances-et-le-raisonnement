function pot = CPD_to_dpot(CPD, domain, ns, evidence)

% function pot = CPD_to_dpot(CPD, domain, ns, evidence)
% domain is the domain of CPD.
% node_sizes(i) is the size of node i.
% evidence{i} is the evidence on the i'th node.

% A table is a multi-dimensional array. A dpot is an object.
% The general purpose code uses potential objects,
% but the fast versions use tables where possible.

if nargin < 4
T = CPD_to_table(CPD, domain, ns);
pot = dpot(domain, ns(domain), T);
   
else
odom = domain(~isemptycell(evidence(domain)));   
ns(odom) = 1;
T = CPD_to_table(CPD, domain, ns, evidence);
pot = dpot(domain, ns(domain), T);
end




