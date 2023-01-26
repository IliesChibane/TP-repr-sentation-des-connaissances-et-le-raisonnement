function T = CPD_to_table(CPD, domain, ns, evidence)
% CPD_TO_TABLE Convert a CPD to a discrete potential, incorporating any evidence (discrete)
% T = CPD_to_table(CPD, domain, ns, evidence)
%
% domain is the domain of CPD.
% node_sizes(i) is the size of node i.
% cnodes = all the cts nodes
% evidence{i} is the evidence on the i'th node.

if nargin<4  %car je ne veut pas pas introduire l'évidence à ce niveau pour le nouveau algorithme

index = mk_multi_index(length(domain), find_equiv_posns([], domain), []);
CPT = CPD_to_CPT(CPD);
T = myreshape(CPT(index{:}), ns(domain));      

else
   
odom = domain(~isemptycell(evidence(domain)));
ns(odom) = 1;
vals = cat(1, evidence{odom});
index = mk_multi_index(length(domain), find_equiv_posns(odom, domain), vals);

CPT = CPD_to_CPT(CPD);
T = myreshape(CPT(index{:}), ns(domain)); 

end