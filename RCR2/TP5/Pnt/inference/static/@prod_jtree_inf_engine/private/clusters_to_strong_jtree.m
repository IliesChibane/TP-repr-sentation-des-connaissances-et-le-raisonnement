function [jtree, root, clusters, B, w] = mk_strong_jtree(clusters, ns, elim_order, MTG)
% MK_SRONG_JTREE Make a strong junction tree.
% [jtree, root, clusters, B, w] = mk_strong_jtree(clusters, ns, elim_order, MTG)
%
% Here is a definition of a strong jtree from Jensen et al. 1994:
% "A junction tree is said to be strong if it has at least one distinguished cluster R,
% called a strong root, s.t. for each pair (C1,C2) of adjacent clusters in the tree,
% with C1 closer to R than C2, there exists and ordering of [the nodes below] C2
% that respects [the partial order] and with the vertices of the separator C1 intersect C2
% preceeding the vertices [below C2] of C2 \ C1."
%          
% For details, see
% - Jensen, Jensen and Dittmer, "From influence diagrams to junction trees", UAI 94.
%
% MTG is the moralized, triangulated graph.
% elim_order is the elimination ordering used to compute MTG.


% Warning: this is a very naive implementation of the algorithm in Jensen et al.

n = length(elim_order);
alpha(elim_order) = n:-1:1;
% alpha(u) = i if we eliminate u at step n-i+1
% i.e., vertices with higher alpha numbers are eliminated before vertices with lower numbers.
% e.g., from the Jensen et al paper
% node a=1 eliminated at step 6, so alpha(a)=16-6+1=11.
% alpha = [11 1 2 10 9 3 4 7 5 8 13 12 6 16 15 14]


% We sort the clusters in order of increasing index. The index of a cluster C is defined as follows.
% Let lower = {u | alpha(u) < alpha(v)}, and
% let v in C be the highest-numbered vertex s.t. the vertices in W = lower intersect C
% have a common neighbor u in U, where U = lower \ C.
% If such a v exists, define index(C) = alpha(v), otherwise, index(C) = 1.
% Intuitively, index(C) is the step in the elimination process at which C disappears.

num_clusters = length(clusters);
index = zeros(1, num_clusters);
for c = 1:num_clusters
  C = clusters{c};
  highest_num = -inf;
  for vi = 1:length(C)
    v = C(vi);
    lower = find(alpha < alpha(v));
    W = myintersect(lower, C);
    U = mysetdiff(lower, C);
    found = 0;
    for ui=1:length(U)
      u = U(ui);
      if mysubset(W, neighbors(MTG, u))
	found = 1;
	break;
      end
    end
    if found
      if alpha(v) > highest_num
	highest_num = alpha(v);
      end
    end
  end
  if highest_num == -inf
    index(c) = 1;
  else
    index(c) = highest_num;
  end
end


% Permute the clusters so that they are ordered according to index
[dummy, cluster_order] = sort(index);
clusters = clusters(cluster_order);

w = zeros(num_clusters, 1); 
B = sparse(num_clusters, 1);
for i=1:num_clusters
  B(i, clusters{i}) = 1;
  w(i) = prod(ns(clusters{i}));
end

% Pearl p113 suggests ordering the clusters by rank of the highest vertex in each cluster.
% However, this will only work if we use maximum cardinality search.


% Join up the clusters so that they satisfy the Running Intersection Property.
% This states that, for all k > 1, S(k) subseteq C(j) for some j < k, where
% S(k) = C(k) intersect (union_{i=1}^{k-1} C(i))
jtree = sparse(num_clusters, num_clusters);
for k=2:num_clusters
  S = [];
  for i=1:k-1
    S = myunion(S, clusters{i});
  end
  S = myintersect(S, clusters{k});
  found = 0;
  for j=1:k-1
    if mysubset(S, clusters{j})
      found = 1;
      break;
    end
  end
  if ~found
    disp(['RIP is violated for cluster ' num2str(k)]);
  end
  jtree(k,j)=1;
  jtree(j,k)=1;
end

% Pearl p113 suggests connecting Ci to a predecessor Cj (j < i) sharing
% the highest number of vertices with Ci (i.e., the heaviest i-j edge
% in the jgraph). However, this will only work if we use maximum cardinality search.

root = 1;


