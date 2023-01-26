function mu = compute_mu_prod(CPD, n, ps, msg,ns)
% COMPUTE_mu Compute mu vector (tabular)
% mu = compute_mu(CPD, n, ps, msg)
% Pearl p183 eq 4.51

T = prod_CPD_and_mu_msgs(CPD, n, ps, msg,ns); 
mu = pot_to_marginal(marginalize_pot(T, n)); 
mu = mu.T(:);                   
