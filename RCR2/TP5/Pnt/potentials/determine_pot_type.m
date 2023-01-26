function pot_type = determine_pot_type(onodes, cnodes, dag)
% DETERMINE_POT_TYPE Determine the type of potential based on the evidence pattern.
% function pot_type = determine_pot_type(onodes, cnodes, dag)
%
% If all hidden nodes are discrete, pot_type = 'd'.
% If all hidden nodes are continuous, pot_type = 'g' (Gaussian).
% If some hidden nodes are discrete, and some cts, pot_type = 'cg' (conditional Gaussian).

n = length(dag);
hnodes = mysetdiff(1:n, onodes);
cts = sparse(1, n);
cts(cnodes) = 1;
if ~any(cts(hnodes))
  pot_type = 'd';
elseif all(cts(hnodes))
  pot_type = 'g';
else 
  pot_type = 'cg';
end
