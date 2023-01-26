
function [MGraph,  clusters, B, w] = dag_to_MG(pnet)
% DAG_TO_MG Moralize and triangulate a DAG, and make a junction tree from its clusters.
% [jtree, clusters, B, w] = dag_to_MG(pnet)
%
% Mgraph(i,j) = 1 iff there is an arc between cluster i and cluster j 
% root = the root cluster
% clusters{i} = the nodes in cluster i
% B(i,j) = 1 iff node j occurs in cluster i
% w(i) = weight of cluster i

N = length(pnet.dag);


%%STEP1: Constructing the Moral Graph

%% Identifying clusters

ns=pnet.node_sizes(:);

clusters = {};

j=1;

for i=1:N
   ps = parents(pnet.dag,i);
%   if ~isempty(ps)   							%sinon j'ai pb lors des rajouts des liens !!!
      clusters{j} = myunion(ps, i);        % the cluster will always contain at least the node i itself
      %valclusters=clusters{j}               % affichage des clusters
      j=j+1;
%   end
   
end

[MGraph,  B, w] = clusters_to_MG(clusters, ns);
   %valjtree=MGraph
   %valroot=root
   %valB=B
   %valW=w
