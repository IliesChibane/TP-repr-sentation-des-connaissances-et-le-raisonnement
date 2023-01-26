function Tbig = divide_by_pot(Tbig, Tsmall)
% DIVIDE_BY_POT Tbig /= Tsmall
% Tbig = divide_by_pot(Tbig, Tsmall)
%
% Tsmall's domain must be a subset of Tbig's domain.


ns = sparse(1, max(Tbig.domain));
ns(Tbig.domain) = Tbig.sizes;
ns(Tsmall.domain) = Tsmall.sizes;
ndx = mk_multiply_table_ndx(Tbig.domain, Tsmall.domain, full(ns));
temp2 = Tsmall.T + (Tsmall.T==0);
if 0 % isempty(ndx)
  temp = Tbig.T(:) ./ temp2(:);
else
  temp = Tbig.T(:) ./ temp2(ndx);
end

Ts = extend_domain_table(Tsmall.T, Tsmall.domain, Tsmall.sizes, Tbig.domain, Tbig.sizes);
% Replace 0s by 1s before dividing. This is valid, Ts(i)=0 iff Tbig(i)=0.
Ts = Ts + (Ts==0);
Tbig.T = Tbig.T ./ Ts;

assert(approxeq(temp(:), Tbig.T(:)));
