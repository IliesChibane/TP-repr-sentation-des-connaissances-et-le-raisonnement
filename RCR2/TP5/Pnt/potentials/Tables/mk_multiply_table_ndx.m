function ndx = mk_multiply_table_ndx(bigdom, smalldom, ns)
% MK_MULTIPLY_TABLE_NDX Compute mapping from small table to big table
% ndx = mk_multiply_table_ndx(bigdom, smalldom, ns)
%
% Example: bigdom = [a b c d], smalldom = [b c], then ndx([a b c d]) = [b c]
% so we can implement multiply_by_table as
% for i=1:prod(ns(bigdom))
%   big(i) = big(i) * small(ndx(i))
% end
% or big = big .* small(ndx)

mask = find_equiv_posns(smalldom, bigdom);
S = prod(ns(bigdom));
if S <= 2^18
  subs = ind2subv(ns(bigdom), 1:S);
  ndx = subv2ind(ns(smalldom), subs(:,mask));
else
  disp(['warning: huge table ' num2str(S)]);
  ndx = zeros(1,S);
  for i=1:S
    subs = ind2subv(ns(bigdom), i);
    ndx(i) = subv2ind(ns(smalldom), subs(mask));
  end
end

if isempty(smalldom)
  ndx = 1;
else
  ndx = ndx(:);
end
