function [MGraph, root, B, w] = cliques_to_MG(cliques, ns)
%
% Input:
%  cliques{i} = nodes in clique i
%  ns(i) = number of values node i can take on
% Output:
%  MGraph(i,j) = 1 iff cliques i and j aer connected
%  root = the clique that should be used as root
%  B(i,j) = 1 iff node j occurs in clique i
%  w(i) = weight of clique i

num_cliques = length(cliques);
w = zeros(num_cliques, 1); 
B = sparse(num_cliques, 1);
for i=1:num_cliques
  B(i, cliques{i}) = 1;
  w(i) = prod(ns(cliques{i}));
end

C1 = B*B';
C1 = setdiag(C1, 0);

% ce bloc pour calculer la taille de l'intersection entre deux cliques
% notons que full est le contraire de sparse
% for i=1:num_cliques   
%   for j=1:num_cliques
%      C1(i,j)=length(intersect(cliques{i}, cliques{j}));
%   end
% end

MGraph = sparse(C1); % Using -C1 gives *maximum* spanning tree

% The root is arbitrary, but since the first pass is towards the root,
% we would like this to correspond to going forward in time in a DBN.
root = num_cliques;


