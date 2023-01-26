function marginal = marginal_family(engine, i)
% MARGINAL_FAMILY Compute the marginal on the specified family (jtree)
% marginal = marginal_family(engine, i)

bnet = bnet_from_engine(engine);
fam = family(bnet.dag, i);
c = engine.clq_ass_to_node(i);
marginal = pot_to_marginal(marginalize_pot(engine.clpot{c}, fam));
