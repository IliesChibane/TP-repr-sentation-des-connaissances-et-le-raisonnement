function engine = prod_pearl_inf_engine(pnet)
% PROD_PEARL_INF_ENGINE Pearl's algorithm (aka belief propagation) for polytrees
% engine = pearl_inf_engine(pnet)
%
% Pearl's algorithm is a generalization of the forwards-backwards algorithm to polytrees.
% (A polytree is like a regular rooted tree, except there may be multiple roots.
% The important point is that there are no undirected cycles.)
% For details, see
% - "Probabilistic Reasoning in Intelligent Systems", Judea Pearl, 1988, 2nd ed.
% We use the two-pass (centralized) message passing protocol described in
% - "Fusion and propogation with multiple observations in belief networks",
%      Peot and Shachter, AI 48 (1991) p. 299-318.
%
% Currently, this implementation assumes that all the nodes are discrete, and have
% either tabular or noisy-or CPDs. For scalar Gaussian nodes, the equations are in Pearl's book;
% the vector versions can be found in 
% - "Inference Using Message Propogation and Topology Transformation in Vector Gaussian
%    Continuous Networks", S. Alag and A. Agogino, UAI 96.
% These Gaussian equations haven't been implemented yet.
%
% SEE ALSO loopy_pearl_inf_engine
directed = 0;

if acyclic(pnet.dag, directed)==0
    errordlg('The DAG is multiply connected, use Junction tree algorithm');
    
    engine=[];
else

N = length(pnet.dag);

% this is where we store stuff between enter_evidence and marginal_nodes
engine.marginal = cell(1,N);
engine.evidence = []; 
engine.msg = [];

% We first send messages up to the root (pivot node), and then back towards the leaves.
% If the pnet is a singly connected graph (no loops), choosing a root induces a directed tree.
% Peot and Shachter discuss ways to pick the root so as to minimize the work,
% taking into account which nodes have changed.
% For simplicity, we always pick the root to be the last node in the graph.
% This means the first pass is equivalent to going forward in time in a DBN.

%engine.root = N; 
engine.root = N-1; 

[engine.adj_mat, engine.preorder, engine.postorder, engine.heights, engine.loopy] = ...
    mk_rooted_tree(pnet.dag, engine.root);
% engine.adj_mat might have different edge orientations from pnet.dag

[engine.parent_index, engine.child_index] = mk_pearl_msg_indices(pnet);

engine = class(engine, 'prod_pearl_inf_engine', inf_engine(pnet));

end