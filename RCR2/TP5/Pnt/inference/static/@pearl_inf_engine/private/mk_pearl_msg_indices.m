function [parent_index, child_index] = mk_pearl_msg_indices(bnet)
% MK_PEARL_MSG_INDICES Compute "port numbers" for message passing
% [parent_index, child_index] = mk_pearl_msg_indices(bnet)
%
% child_index{n}(c) = i means c is n's i'th child, i.e., i = find_equiv_posns(c, children(n))
% child_index{n}(c) = 0 means c is not a child of n.
% parent_index is defined similarly.
% We need to use these indices since the pi_from_parent/ lambda_from_child cell arrays
% cannot be sparse, and hence cannot be indexed by the actual number of the node.
% Instead, we use the number of the "port" on which the message arrived.

N = length(bnet.dag);
child_index = cell(1,N);
parent_index = cell(1,N);
for n=1:N
  cs = children(bnet.dag, n);
  child_index{n} = sparse(1,N);
  for i=1:length(cs)
    c = cs(i);
    child_index{n}(c) = i;
  end
  ps = parents(bnet.dag, n);
  parent_index{n} = sparse(1,N);
  for i=1:length(ps)
    p = ps(i);
    parent_index{n}(p) = i;
  end
end
