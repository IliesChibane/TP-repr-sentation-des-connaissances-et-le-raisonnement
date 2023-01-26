function b = acyclic(adj_mat, directed)
% ACYCLIC Returns true iff the graph has no (directed) cycles.
% b = acyclic(adj_mat, directed)


[d, pre, post, height, cycle] = dfs(adj_mat,1,directed);
b = ~cycle;

