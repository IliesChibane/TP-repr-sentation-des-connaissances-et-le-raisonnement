function m = marginal_family(engine, n)
% MARGINAL_FAMILY Compute the marginal on i's family (pearl)
% m = marginal_family(engine, n)

% The method is similar to the following HMM equation:
% xi(i,j,t) = normalise( alpha(i,t) * transmat(i,j) * obsmat(j,t+1) * beta(j,t+1) )
% where xi(i,j,t) = Pr(Q(t)=i, Q(t+1)=j | y(1:T))   
% beta == lambda, alpha == pi, alpha from each parent = pi msg

bnet = bnet_from_engine(engine);
ns = bnet.node_sizes;
ps = parents(bnet.dag, n);
dom = [ps n];
e = bnet.equiv_class(n);
T = dpot(dom, ns(dom), CPD_to_CPT(bnet.CPD{e}));
for j=1:length(ps)
  p = ps(j);
  pi_msg = dpot(p, ns(p), engine.msg{n}.pi_from_parent{j});
  T = multiply_by_pot(T, pi_msg);
end         
lambda = dpot(n, ns(n), engine.msg{n}.lambda);
T = multiply_by_pot(T, lambda);
T = normalize_pot(T);
m = pot_to_marginal(T);

m.T = shrink_obs_dims_in_table(m.T, dom, engine.evidence);
