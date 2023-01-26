function [engine, loglik] = enter_evidence(engine, evidence)
% ENTER_EVIDENCE Add the specified evidence to the network (pearl)
% [engine, loglik] = enter_evidence(engine, evidence)
% evidence{i} = [] if if X(i) is hidden, and otherwise contains its observed value (scalar or column vector)

engine.evidence = evidence;

bnet = bnet_from_engine(engine);
N = length(bnet.dag);
ns = bnet.node_sizes(:);

% SCALING
% The only difference between the defns in Pearl and Peot and Shachter
% is that Pearl defines pi_X(x) = Pr(X=x | ev above X)
% and Peot defines pi_X(x) = Pr(X=x, ev above X).
% This difference only affects the computation of pi msgs.
% The advantages of normalizing are
% (1) prevents underflow (esp. important when iterating many times)
% (2) it ensures the pi msgs sum to 1, which is needed for noisy-or nodes.
%
% In addition to scaling the pi's, we must scale the lambda's to prevent underflow (esp when iterating).
% Hence we define lambda_X(x) = c Pr(ev below X | X=x), where c is the normalizing constant.
% Note that the lambda's are not conditional probabilities, and do not automatically sum to 1.
% Again, this just affects the computation of the lambda msgs.
% Multiplying them by an arbitrary constant is valid: see Pearl p183 eq 4.52.
%
% The disadvantage of scaling is that we lose information, making it hard (impossible?)
% to compute the likelihood. Also, scaling makes cutset conditioning harder.
% If we multiplied all the pi msg scaling factors together, it might equal the likelihood,

all_tabular = 1;
for i=1:max(bnet.equiv_class)
  if ~isa(bnet.CPD{bnet.equiv_class(i)}, 'tabular_CPD')
    all_tabular = 0;
    break;
  end
end
%do_scaling = ~all_tabular;
do_scaling = 1;
if do_scaling & nargout == 2
  disp('warning: the loglik value will be wrong');
end
  
rand_init = 0;
% The initial values of the msgs don't matter in the centralized version,
% since we always compute a msg before using it.
msg = init_msgs(bnet.dag, ns, evidence, rand_init);

scale = ones(1,N);
% Send messages from leaves to root
for i=1:N-1
  n = engine.postorder(i);
  above = parents(engine.adj_mat, n);
  [msg, scale] = send_msgs_to_some_neighbors(n, msg, above, bnet, ...
				    engine.child_index, engine.parent_index, do_scaling, scale);
end

% Process root
n = engine.root;
cs = children(bnet.dag, n);
msg{n}.lambda = compute_lambda(n, cs, msg);
ps = parents(bnet.dag, n);
msg{n}.pi = compute_pi(bnet.CPD{bnet.equiv_class(n)}, n, ps, msg);

% Send messages from root to leaves
for i=1:N
  n = engine.preorder(i);
  below = children(engine.adj_mat, n);
  [msg, scale] = send_msgs_to_some_neighbors(n, msg, below, bnet, ...
				    engine.child_index, engine.parent_index, do_scaling, scale);
end

engine.marginal = cell(1,N);
for n=1:N
  [bel, lik] = normalise(msg{n}.pi .* msg{n}.lambda);     
  engine.marginal{n} = bel;
end

lik = prod(scale);
engine.msg = msg; % needed by marginal_family
loglik = log(lik);

  
%%%%%%%%%%

function [msg, scale] = send_msgs_to_some_neighbors(n, msg, valid_nbrs, bnet, ...
						  child_index, parent_index, do_scaling, scale)

scalef = 1;
ns = bnet.node_sizes;
dag = bnet.dag;
e = bnet.equiv_class(n);
CPD = bnet.CPD{e};

cs = children(dag, n);
ps = parents(dag, n);

ps2 = myintersect(parents(dag, n), valid_nbrs);
for p=ps2(:)'
  msg{n}.lambda = compute_lambda(n, cs, msg);
  lam_msg = compute_lambda_msg(CPD, n, ps, msg, p);
  if do_scaling, lam_msg = normalise(lam_msg); end
  j = child_index{p}(n); % n is p's j'th child
  msg{p}.lambda_from_child{j} = lam_msg(:);
end

cs2 = myintersect(cs, valid_nbrs);
for c=cs2(:)'
  msg{n}.pi = compute_pi(CPD, n, ps, msg);
  pi_msg = compute_pi_msg(n, cs, msg, c);
  if do_scaling, [pi_msg, scale(n)] = normalise(pi_msg); end
  j = parent_index{c}(n); % n is c's j'th parent
  msg{c}.pi_from_parent{j} = pi_msg;
end



%%%%%%%

function lambda = compute_lambda(n, cs, msg)
% Pearl p183 eq 4.50
lambda = prod_lambda_msgs(n, cs, msg);

%%%%%%%

function pi_msg = compute_pi_msg(n, cs, msg,  c)
% Pearl p183 eq 4.53 and 4.51
pi_msg = msg{n}.pi .* prod_lambda_msgs(n, cs, msg, c);

%%%%%%%%%

function lam = prod_lambda_msgs(n, cs, msg, except)

if nargin < 4, except = -1; end

lam = msg{n}.lambda_from_self(:);
for i=1:length(cs)
  c = cs(i);
  if c ~= except
    lam = lam .* msg{n}.lambda_from_child{i};
  end
end   
