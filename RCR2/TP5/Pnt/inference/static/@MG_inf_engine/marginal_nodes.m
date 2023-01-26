function marginal = marginal_nodes(engine, query)
% MARGINAL_NODES Compute the marginal on the specified query nodes (jtree)
% marginal = marginal_nodes(engine, query)
%
% 'query' must be a subset of some clique; an error will be raised if not.

c = clq_containing_nodes(engine, query);
marginal = pot_to_marginal(marginalize_pot(engine.clpot{c}, query));
