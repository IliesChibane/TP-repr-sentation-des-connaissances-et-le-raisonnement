function engine = jtree_inf_engine(pnet, obs_nodes, clusters, stages, query)
% JTREE_INF_ENGINE Junction tree inference engine
% engine = jtree_inf_engine(pnet, obs_nodes, clusters, stages, onepass)
%
% 'obs_nodes' is an optional argument (default []) that specifies which nodes
% will probably be observed. Knowing this might result in a more efficient elimination
% ordering, since observed nodes can essentially be removed from the graph.
%
% 'clusters' is an optional argument (default []). If clusters{i}=S,
% then it is guaranteed to be possible to compute the marginal on the nodes in S.
% This is used by bk_inf_engine and structure learning.
%
% 'stages' is an optional argument (default {1:N}). It constrains the elimination ordering to a
% temporal sequence. This is used by jtree_unrolled_dbn_inf_engine.
%
% 'query' is an optional argument (default: []). If non-emtpy, the root of the junction tree
% will be a cluster that contains query. This is used by jtree_onepass.
%
% For more details on the junction tree algorithm, see
% - "Probabilistic networks and expert systems", Cowell, Dawid, Lauritzen and Spiegelhalter, Springer, 1999
% - "Inference in Belief Networks: A procedural guide", C. Huang and A. Darwiche, 
%      Intl. J. Approximate Reasoning, 15(3):225-263, 1996.


% Mathworks says you have to put all this crap up front when defining a constructor...

if nargin==0
  engine.dummy = [];
  engine = class(engine, 'jtree_inf_engine');
  disp('jtree inf engine no args');
  return;
elseif isa(pnet, 'jtree_inf_engine')
  engine = pnet;
  disp('jtree inf engine self arg');
  return;
end


if nargin < 2, obs_nodes = []; end
if nargin < 3, clusters = []; end
if nargin < 4, stages = { 1:length(pnet.dag) }; end
if nargin < 5, query = []; end

N = length(pnet.dag);

% I: BUILDING JUNCTION TREE
[engine.jtree, root, engine.clusters, B, w] = dag_to_jtree(pnet, obs_nodes, stages, clusters);


engine.clusters_bitv = B;
engine.cluster_weight = w;

if ~isempty(query)
  root2 = 0;
  cl = engine.clusters;
  for i=1:length(cl)
    if mysubset(query, cl{i})
      root2 = i;
      break;
    end
  end
  assert(root2 > 0);
  root = root2;
end

% Make the jtree rooted, so there is a fixed message passing order.

[engine.jtree, engine.preorder, engine.postorder] = mk_rooted_tree(engine.jtree, root);


engine.root = root;

% A node can be a member of many clusters, but is assigned to exactly one, to avoid
% double-counting its CPD. We assign node i to cluster c if c is the "lightest" cluster that
% contains i's family, so it can accomodate its CPD.

engine.clq_ass_to_node = zeros(1, N);
num_clusters = length(engine.clusters);
for i=1:N
  %c = clq_containing_nodes(engine, family(pnet.dag, i));
  clqs_containing_family = find(all(B(:,family(pnet.dag, i)), 2)); 
  % all selected columns must be 1
  c = clqs_containing_family(argmin(w(clqs_containing_family)));
  engine.clq_ass_to_node(i) = c;
end



% Compute the separators between connected clusters.

[is,js] = find(engine.jtree > 0);
engine.separator = cell(num_clusters, num_clusters);
for k=1:length(is)
  i = is(k); j = js(k);
  engine.separator{i,j} = find(B(i,:) & B(j,:)); 
end



C = length(engine.clusters);
engine.clpot = cell(1,C);
engine.seppot = cell(C,C);


engine = class(engine, 'jtree_inf_engine', inf_engine(pnet));

