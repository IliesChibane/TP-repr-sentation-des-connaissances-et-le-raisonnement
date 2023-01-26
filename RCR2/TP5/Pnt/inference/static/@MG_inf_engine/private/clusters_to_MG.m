function [MGraph,  B, w] = clusters_to_MG(clusters, ns)

'ici'
%
% Input:
%  clusters{i} = nodes in cluster i
%  ns(i) = number of values node i can take on
% Output:
%  MGraph(i,j) = 1 iff clusters i and j aer connected
%  root = the cluster that should be used as root
%  B(i,j) = 1 iff node j occurs in cluster i
%  w(i) = weight of cluster i

num_clusters = length(clusters);
w = zeros(num_clusters, 1); 
B = sparse(num_clusters, 1);
for i=1:num_clusters
  B(i, clusters{i}) = 1;
  w(i) = prod(ns(clusters{i}));
end

C1 = B*B';
C1 = setdiag(C1, 0);

% ce bloc pour calculer la taille de l'intersection entre deux clusters
% notons que full est le contraire de sparse
% for i=1:num_clusters   
%   for j=1:num_clusters
%      C1(i,j)=length(intersect(clusters{i}, clusters{j}));
%   end
% end

MGraph = sparse(C1); % Using -C1 gives *maximum* spanning tree

% The root is arbitrary, but since the first pass is towards the root,
% we would like this to correspond to going forward in time in a DBN.


