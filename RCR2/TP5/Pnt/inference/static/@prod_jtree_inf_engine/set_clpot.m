function engine = set_clpot(engine, clpot)
% SET_CLPOT Set the field 'clpot', which contains the clique potentials after propagation
% engine = set_clpot(engine, clpot)
%
% This is used by fast_jtree_inf_engine/enter_evidence 
% as a workaround for Matlab's annoying privacy control

engine.clpot = clpot;
