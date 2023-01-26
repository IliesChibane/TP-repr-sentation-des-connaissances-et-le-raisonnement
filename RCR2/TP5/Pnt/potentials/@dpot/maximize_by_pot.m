function Tbig = maximize_by_pot(Tbig, Tsmall)
% Tbig = minimize_by_pot(Tbig, Tsmall)
%
% Tsmall's domain must be a subset of Tbig's domain.


Ts = extend_domain_table(Tsmall.T, Tsmall.domain, Tsmall.sizes, Tbig.domain, Tbig.sizes);

Tbig.T = max(Tbig.T, Ts);

%new_pot_cluster= Tbig.T(:,:)



%assert(prod(Tbig.sizes)==prod(size(Tbig.T)));
%j'ai enlevé

