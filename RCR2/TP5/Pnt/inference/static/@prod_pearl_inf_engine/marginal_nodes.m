function marginal = marginal_nodes(engine, query)
% MARGINAL_NODES Compute the marginal on the specified query nodes (pearl)
% marginal = marginal_nodes(engine, query)
%
% 'query' must be a single node.
   
assert(length(query)==1);

T = engine.marginal{query};
Tsmall = shrink_obs_dims_in_table(T, query, engine.evidence);
marginal.domain = query;
marginal.T = Tsmall;
