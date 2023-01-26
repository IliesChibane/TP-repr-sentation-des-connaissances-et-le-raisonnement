function pot = CPD_to_cgpot(CPD, domain, ns, cnodes, evidence)
% CPD_TO_CGPOT Convert a CPD to a CG potential, incorporating any evidence (discrete)
% pot = CPD_to_cgpot(CPD, domain, ns, cnodes, evidence)
%
% domain is the domain of CPD.
% node_sizes(i) is the size of node i.
% cnodes
% evidence{i} is the evidence on the i'th node.


odom = domain(~isemptycell(evidence(domain)));
vals = cat(1, evidence{odom});
map = find_equiv_posns(odom, domain);
index = mk_multi_index(length(domain), map, vals);
CPT = CPD_to_CPT(CPD);
CPT = CPT(index{:});
CPT = CPT(:);
ns(odom) = 1;
can = cell(1, length(CPT));
for i=1:length(CPT)
  can{i} = cpot([], [], log(CPT(i)));
end
pot = cgpot(domain, [], ns, can);
