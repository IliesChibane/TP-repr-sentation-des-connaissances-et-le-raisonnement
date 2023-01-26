function ndx = mk_marginalise_table_ndx(bigdom, smalldom, ns)
% MK_MARGINALISE_TABLE_NDX Compute mapping from big table to small table
% ndx = mk_marginalise_table_ndx(bigdom, smalldom, ns)
%
% Example: bigdom = [a b c d], smalldom = [b c], then ndx([b c], [a d]) = [a b c d]
% so we can implement marginalize_table as
% for i=1:prod(ns(smalldom))
%   s = 0;
%   for j=1:prod(ns(diffdom)  % diffdom = bigdom \ smalldom
%     s = s + big(ndx(i,j))
%   end
%   small(i) = s;
% end
% or small = sum(big(ndx), 2)

smallmask = find_equiv_posns(smalldom, bigdom);
diffdom = mysetdiff(bigdom, smalldom);
diffmask = find_equiv_posns(diffdom, bigdom);
ndx = zeros(prod(ns(smalldom)), prod(ns(diffdom)));
S = prod(ns(bigdom));
ns = ns(:);
if  S <= 2^18
  subs = ind2subv(ns(bigdom), 1:S);
  %ndx2 = subv2ind([ns(smalldom) ns(diffdom)], [subs(:,smallmask) subs(:,diffmask)]);
  ndx2 = subv2ind([ns(smalldom);ns(diffdom)], [subs(:,smallmask) subs(:,diffmask)]);
  ndx(ndx2) = 1:S;
else
  disp(['warning: huge table ' num2str(S)]);
  for i=1:S
    subs = ind2subv(ns(bigdom), i);
    %j = subv2ind([ns(smalldom) ns(diffdom)], [subs(smallmask) subs(diffmask)]);
    j = subv2ind([ns(smalldom); ns(diffdom)], [subs(smallmask) subs(diffmask)]);
    ndx(j) = i;
  end
end

%ndx = ndx(:);
