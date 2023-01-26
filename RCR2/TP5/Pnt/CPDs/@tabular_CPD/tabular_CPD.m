function CPD = tabular_CPD(bnet, self, CPT, prior, clamp)
% TABULAR_CPD Make a conditional prob. distrib. which is a table (CPT).
%
% CPD = TABULAR_CPD(BNET, NODE_NUM)
% The CPT will be initialized randomly. It is stored as follows.
%   CPD.CPT(p1, ..., pn, s) = Pr(self=s | Pa(1) = p1, ..., Pa(n) = pn)
% The low numbered parents come before the high numbered parents.
% The last dimension always sums to 1.
% All the parents must be discrete.
%
% CPD = TABULAR_CPD(BNET, NODE_NUM, CPT)
% Use the specified CPT.
% For example, suppose node X3 has 2 parents, X1 and X2, and all nodes are binary.
% To enter the following CPT (enumerated in matlab order: leftmost column toggles fastest)
%
% X1 X1 Pr(X3=1)  Pr(X3=2)
%------------------------
% 1  1   0.1       0.9
% 2  1   0.2       0.8
% 1  2   0.3       0.7
% 2  2   0.4       0.6
% 
% use CPT(:) = [0.1 0.2 0.3 0.4 0.9 0.8 0.7 0.6];
% Here is an alternative way of entering the same information
%  CPT(1,1,1) = 0.1; CPT(2,1,1) = 0.2; ...; CPT(2,2,2) = 0.6;
% Note that matlab counts from 1. Hence False==1, True==2.
%
% CPD = TABULAR_CPD(BNET, NODE_NUM, CPT, PRIOR)
% Use the specified Dirichlet prior (pseudo counts).
% This is useful when learning, to prevent estimating zeros in the CPT just because a particular
% case was not seen. A simple example is the uniform prior given by
%   sz = mysize(CPT); prior = 0.001*normalise(myones(sz))
% where 0.001 is the equivalent sample size.
% prior = all 0s by default (maximum-likelihod estimation).
%
% CPD = TABULAR_CPD(BNET, NODE_NUM, CPT, PRIOR, CLAMP)
% If clamp = 1, the CPT will not be adjusted during learning. Default: clamp = 0.

if nargin==0
  disp('calling tabular_CPD constructor with 0 arguments');
  %CPD = init;
  CPD.dummy = [];
  CPD = class('CPD', 'tabular_CPD');
  return;
elseif isa(bnet, 'tabular_CPD')
  disp('calling tabular_CPD constructor with self argument');
  CPD = bnet;
  return;
end

%CPD = init;

ns = bnet.node_sizes;
fam = family(bnet.dag, self);

%assert(isempty(myintersect(fam, bnet.cnodes)));

if nargin < 3 | isempty(CPT), CPT = mk_stochastic(myrand(ns(fam))); end
if nargin < 4, prior = 0*myones(ns(fam)); end
if nargin < 5, clamp = 0; end

CPD.self = self;
CPD.CPT = myreshape(CPT, ns(fam));
%CPD.sizes = ns(fam);

% For learning
CPD.prior = myreshape(prior, ns(fam));
CPD.counts = zeros(size(CPD.CPT));

% For BIC
ps = parents(bnet.dag, self);
if ~clamp
  CPD.nparams = prod([ns(ps) ns(self)-1]); % sum-to-1 constraint reduces the effective arity of the node by 1
else
  CPD.nparams = 0;
end
CPD.nsamples = 0;

CPD = class(CPD, 'tabular_CPD', discrete_CPD(clamp));

%%%%

function CPD = init() % this ensures we define the fields in the same order every time

CPD.self = [];
CPD.CPT = [];
CPD.prior = [];
CPD.counts = [];
CPD.nparams = [];
CPD.nsamples = [];
CPD = class(CPD, 'tabular_CPD', discrete_CPD(clamp));






