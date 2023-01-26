function CPD = reset_ess(CPD)
% RESET_ESS Reset the Expected Sufficient Statistics of a tabular node.
% CPD = reset_ess(CPD)

CPD.counts = zeros(size(CPD.CPT));
CPD.nsamples = 0;    
