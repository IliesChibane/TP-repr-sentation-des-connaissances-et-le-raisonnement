function [jtree, root, clusters, B, w] = dag_to_jtree(bnet, obs_nodes, stages, clusters)
% DAG_TO_JTREE Moralize and triangulate a DAG, and make a junction tree from its clusters.
% [jtree, root, clusters, B, w] = dag_to_jtree(bnet, obs_nodes, stages, clusters)
%
% jtree(i,j) = 1 iff there is an arc between cluster i and cluster j 
% root = the root cluster
% clusters{i} = the nodes in cluster i
% B(i,j) = 1 iff node j occurs in cluster i
% w(i) = weight of cluster i


N = length(bnet.dag);
%%STEP1: Constructing the Moral Graph

[MG, moral_edges]  = moralize(bnet.dag);

% Add extra arcs between nodes in each cluster to ensure they occur in the same cluster
for i=1:length(clusters)
  c = clusters{i};
  MG(c,c) = 1;
end
MG = setdiag(MG, 0);


%%STEP2: Trianulating the moral graph + STEP3: Identifying clusters

% Find an optimal elimination ordering (NP-hard problem!)
ns = bnet.node_sizes(:);
ns(obs_nodes) = 1; % observed nodes have only 1 possible value

partial_order = [];
%% il ya des contraintes si on a des neouds discret et continus à la fois mais si 
%% tous les noeuds sont discrets alors partial_order=[]


if isempty(partial_order)
   elim_order = best_first_elim_order(MG, ns, stages);
%   valelimorder=elim_order  %affichage
else
  elim_order = strong_elim_order(MG, ns, partial_order);
end

[MTG, clusters, fill_in_edges]  = triangulate(MG, elim_order);


%%STEP4: Building and optimal Junction tree

% Connect the clusters up into a jtree,
if isempty(partial_order)
   [jtree, root, B, w] = clusters_to_jtree(clusters, ns);
   %on est ici car partial_order=[]
   
else
  disp('using strong triangulation');
  [jtree, root, clusters, B, w] = clusters_to_strong_jtree(clusters, ns, elim_order, MTG);
end

% Find the clusters containing each node, and check they form a connected subtree
clqs_con_node = cell(1,N);
for i=1:N
  clqs_con_node{i} = find(B(:,i))';
end
check_jtree_property(clqs_con_node, jtree);


if 0
%elim_order
%moral_edges
fill_in_edges
%celldisp(clusters)
C = length(clusters);
sz = zeros(1,C);
for i=1:C
  cl = clusters{i};
  sz(i) = length(cl);
  if ~isequal(cl, family(bnet.dag, cl(end)))
    fprintf('non family cluster %d\n', i); cl
  end
end
sz
end

