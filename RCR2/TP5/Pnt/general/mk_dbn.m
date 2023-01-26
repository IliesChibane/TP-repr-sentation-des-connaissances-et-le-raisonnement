function bnet = mk_dbn(intra, inter, node_sizes, dnodes, eclass1, eclass2, intra1)
% MK_DBN Make a Dynamic Bayesian Network structure.
%
% BNET = MK_DBN(INTRA, INTER, NODE_SIZES) makes a DBN with arcs
% from i in slice t to j in slice t iff intra(i,j) = 1, and 
% from i in slice t to j in slice t+1 iff inter(i,j) = 1,
% for i,j in {1, 2, ..., n}, where n = num. nodes per slice, and t >= 1.
% node_sizes(i) is the number of values node i can take on.
% The nodes are assumed to be in topological order. Use TOPOLOGICAL_SORT if necessary.
%
% BNET = MK_DBN(INTRA, INTER, NODE_SIZES, DISCRETE_NODES) makes the specified nodes discrete-valued; the
% rest are assumed continuous-valued vectors. node_sizes(i) specifies
% the arity of node i (if discrete) or its dimensionality/length (if continuous).
% The default is that all nodes are discrete.
%
% BNET = MK_DBN(INTRA, INTER, NODE_SIZES, DISCRETE_NODES, EQUIV_CLASS1, EQUIV_CLASS2) puts different nodes
% into the same equivalence class. equiv_class1(i) = j means node i in slice 1 gets its parameters from
% bnet.CPD{j}, i.e., nodes i and j have tied parameters.
% equiv_class2(i) = j means node i in slice t>=2 gets its parameters from bnet.CPD{j}.
% This is useful if you have a repetitive network structure, e.g. a DBN.
% The default is equiv_class1 = 1:n, equiv_class2 = (1:n)+n, i.e., no parameter tieing.
%
% BNET = MK_DBN(INTRA, INTER, NODE_SIZES, DISCRETE_NODES, EQUIV_CLASS1, EQUIV_CLASS2, INTRA1)
% allows you to specify a different topology for the first slice than for the others.
%
% After calling this function, you must specify the parameters (conditional probability
% distributions) using bnet.CPD{i} = gaussian_CPD(...) or tabular_CPD(...) etc.

n = length(intra);
if nargin < 4, dnodes = 1:n; end
if nargin < 5, eclass1 = 1:n; end
if nargin < 6, eclass2 = (1:n)+n; end
if nargin < 7, intra1 = intra; end

bnet.intra = intra;
bnet.intra1 = intra1;
bnet.inter = inter;
ns = node_sizes;
bnet.node_sizes_slice = ns(:)';
bnet.node_sizes = [ns(:) ns(:)];

cnodes = mysetdiff(1:n, dnodes);
bnet.dnodes_slice = dnodes;
bnet.cnodes_slice = cnodes;
bnet.dnodes = [dnodes dnodes+n];
bnet.cnodes = [cnodes cnodes+n];

bnet.equiv_class = [eclass1(:) eclass2(:)];
bnet.CPD = cell(1,max(bnet.equiv_class(:)));

dag = zeros(2*n);
dag(1:n,1:n) = intra1;
dag(1:n,(1:n)+n) = inter;
dag((1:n)+n,(1:n)+n) = intra;
bnet.dag = dag;

directed = 1;
assert(acyclic(dag,directed));
