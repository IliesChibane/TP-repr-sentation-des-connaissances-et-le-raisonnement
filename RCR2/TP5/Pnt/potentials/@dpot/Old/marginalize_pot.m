function smallpot = marginalize_pot(bigpot, onto)
% MARGINALIZE_POT Marginalize a dpot onto a smaller domain.
% smallpot = marginalize_pot(bigpot, onto)

ns = zeros(1, max(bigpot.domain));
ns(bigpot.domain) = bigpot.sizes;
smallpot = dpot(onto, ns(onto));

dom = bigpot.domain;
sum_over = mysetdiff(dom, onto);
ndx = find_equiv_posns(sum_over, dom);

smallpot.T = bigpot.T;
%smallpot.T = myreshape(bigpot.T, bigpot.sizes);
for i=1:length(ndx)
  smallpot.T = sum(smallpot.T, ndx(i));
end

% remove summed out dimensions
% we don't use squeeze, because it would remove singleton dimensions
% that may not have been summed out

%smallpot.T = reshape(smallpot.T, smallpot.sizes);
smallpot.T = squeeze(smallpot.T);
smallpot.T = myreshape(smallpot.T, smallpot.sizes);

%assert(prod(smallpot.sizes)==prod(size(smallpot.T)));

ndx = mk_marginalise_table_ndx(bigpot.domain, onto, ns);
temp = myreshape(bigpot.T, [prod(ns(onto)) prod(ns(sum_over))]);
temp = sum(temp(ndx), 2);
assert(approxeq(temp(:), smallpot.T(:)));
