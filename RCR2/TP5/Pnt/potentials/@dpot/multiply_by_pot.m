function Tbig = multiply_by_pot(Tbig, Tsmall)
% MULTIPLY_BY_POT Tbig *= Tsmall
% Tbig = multiply_by_pot(Tbig, Tsmall)
%
% Tsmall's domain must be a subset of Tbig's domain.

Ts = extend_domain_table(Tsmall.T, Tsmall.domain, Tsmall.sizes, Tbig.domain, Tbig.sizes);
Tbig.T = Tbig.T .* Ts;
assert(prod(Tbig.sizes)==prod(size(Tbig.T)));

