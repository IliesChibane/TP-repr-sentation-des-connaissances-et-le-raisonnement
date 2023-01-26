function mu = compute_mu(CPD, n, ps, msg,ns)
% COMPUTE_mu Compute mu vector (tabular)
% mu = compute_mu(CPD, n, ps, msg)
% Pearl p183 eq 4.51


T = min_CPD_and_mu_msgs(CPD, n, ps, msg,ns); % min(,min)

mu = pot_to_marginal(marginalize_pot(T, n)); % max_u
mu = mu.T(:);                   
