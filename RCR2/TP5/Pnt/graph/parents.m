function ps = parents(adj_mat, i)
%
% ps = parents(adj_mat, i)
% Return the list of parents of node i

ps = find(adj_mat(:,i))';
