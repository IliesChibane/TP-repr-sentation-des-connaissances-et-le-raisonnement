function CPD = update_ess(CPD, fmarginal, evidence, ns, cnodes)
% UPDATE_ESS Update the Expected Sufficient Statistics of a tabular node.
% CPD = update_ess(CPD, family_marginal, evidence, node_sizes, cnodes)

if ~adjustable_CPD(CPD), return; end

fullm = add_ev_to_dmarginal(fmarginal, evidence, ns, cnodes);

%fprintf('updating ess for %d\n', CPD.self);
%fullm.T

CPD.counts = CPD.counts + fullm.T;

CPD.nsamples = CPD.nsamples + 1;            

