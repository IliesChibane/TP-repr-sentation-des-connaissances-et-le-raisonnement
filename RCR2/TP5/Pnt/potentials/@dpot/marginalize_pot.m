function smallpot = marginalize_pot(bigpot, onto)
% MARGINALIZE_POT Marginalize a dpot onto a smaller domain.
% smallpot = marginalize_pot(bigpot, onto)

ns = zeros(1, max(bigpot.domain));

ns(bigpot.domain) = bigpot.sizes;

smallpot = dpot(onto, ns(onto));

dom = bigpot.domain;
max_over = mysetdiff(dom, onto);
ndx = find_equiv_posns(max_over, dom);

smallpot.T = bigpot.T;

for i=1:length(ndx)
   
smallpot.T = max(smallpot.T,[], ndx(i));
   
end


% remove (summed) maxed out dimensions
% we don't use squeeze, because it would remove singleton dimensions
% that may not have been (summed) maxed out

%smallpot.T = reshape(smallpot.T, smallpot.sizes);


%smallpot.T = squeeze(smallpot.T);



smallpot.T = myreshape(smallpot.T, smallpot.sizes);




