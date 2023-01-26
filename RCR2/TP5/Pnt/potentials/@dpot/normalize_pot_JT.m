function [pot, loglik] = normalize_pot_JT(pot)
% NORMALIZE_POT Convert the discrete potential Pi(X,E) into Pi(X|E) and return log Pi(E).
% [pot, loglik] = normalize_pot(pot)

%valnn=pot.T(:,:)
[pot.T, lik] = normalise(pot.T);
%valn=pot.T(:,:)

loglik = log(lik + (lik==0)*eps);

      
