function CPD = maximize_params(CPD)
% MAXIMIZE_PARAMS Set the params of a tabular node to their ML/MAP values.
% CPD = maximize_params(CPD)

if ~adjustable_CPD(CPD), return; end

%assert(approxeq(sum(CPD.counts(:)), CPD.nsamples));
CPD.CPT = mk_stochastic(CPD.counts + CPD.prior);
