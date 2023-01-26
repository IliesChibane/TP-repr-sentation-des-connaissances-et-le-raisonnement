function Tbig = multiply_by_pot(Tbig, Tsmall)
% MULTIPLY_BY_POT Tbig *= Tsmall
% Tbig = multiply_by_pot(Tbig, Tsmall)
%
% Tsmall's domain must be a subset of Tbig's domain.

ns = sparse(1, max(Tbig.domain));
ns(Tbig.domain) = Tbig.sizes;
ns(Tsmall.domain) = Tsmall.sizes;
ndx = mk_multiply_table_ndx(Tbig.domain, Tsmall.domain, full(ns));
if 0 % isempty(ndx)
  temp = Tbig.T(:) .* Tsmall.T(:);
else
  temp = Tbig.T(:) .* Tsmall.T(ndx);
end

Ts = extend_domain_table(Tsmall.T, Tsmall.domain, Tsmall.sizes, Tbig.domain, Tbig.sizes);
Tbig.T = Tbig.T .* Ts;

assert(prod(Tbig.sizes)==prod(size(Tbig.T)));

assert(approxeq(temp(:), Tbig.T(:)));
