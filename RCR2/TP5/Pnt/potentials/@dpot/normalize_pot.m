function [pot] = normalize_pot(pot)
% NORMALIZE_POT Convert the discrete potential Pi(X,E) into Pi(X|E) and return log Pi(E).
% [pot, loglik] = normalize_pot(pot)

[pot.T] = normalise(pot.T);

      
