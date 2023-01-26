function lam_msg = compute_lambda_msg(CPD, n, ps, msg, p,ns)
% COMPUTE_LAMBDA_MSG Compute lambda message (tabular)
% lam_msg = compute_lambda_msg(CPD, n, ps, msg, p)
% Pearl p183 eq 4.52

T = min_CPD_and_mu_msgs(CPD, n, ps, msg, ns, p);
mysize = length(msg{n}.lambda);
lambda = dpot(n, mysize, msg{n}.lambda);
T = minimize_by_pot(T, lambda);
lam_msg = pot_to_marginal(marginalize_pot(T, p));
lam_msg = lam_msg.T;           

