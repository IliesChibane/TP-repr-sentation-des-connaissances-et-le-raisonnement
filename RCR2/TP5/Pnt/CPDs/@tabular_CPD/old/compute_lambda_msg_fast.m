function lam_msg = compute_lambda_msg_fast(CPD, n, ps, msg, p, ndx)

T = prod_CPD_and_pi_msgs_fast(CPD, n, ps, msg, p, ndx);
mysize = length(msg{n}.lambda);
lambda = dpot(n, mysize, msg{n}.lambda);
T = multiply_by_pot(T, lambda);
lam_msg = pot_to_marginal(marginalize_pot(T, p));
lam_msg = lam_msg.T;           

