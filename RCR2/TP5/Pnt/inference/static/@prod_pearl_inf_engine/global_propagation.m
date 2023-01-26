function [engine] = global_propagation(engine, evidence)
% ENTER_EVIDENCE Add the specified evidence to the network (pearl)
% [engine, loglik] = enter_evidence(engine, evidence)
% evidence{i} = [] if if X(i) is hidden, and otherwise contains its observed value (scalar or column vector)
%
% The loglik return value will only be correct if all CPDs are tabular.
pnet = pnet_from_engine(engine);
N = length(pnet.dag);
ns = pnet.node_sizes(:);

%'----------------------Initialization ------------------'

all_tabular = 1;
for i=1:max(pnet.equiv_class)
  if ~isa(pnet.CPD{pnet.equiv_class(i)}, 'tabular_CPD')
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
msg = init_msgs(pnet.dag, ns, evidence, rand_init);

%'----------------------Collect evidence ------------------'

% Send messages from leaves to root
for i=1:N-1
 n = engine.postorder(i);
 above = parents(engine.adj_mat, n);

 msg = send_msgs_to_some_neighbors(n, msg, above, pnet, ...
     engine.child_index, engine.parent_index, do_scaling);
end

% Process root
n = engine.root;
cs = children(pnet.dag, n);
msg{n}.lambda = compute_lambda(n, cs, msg);
ps = parents(pnet.dag, n);
msg{n}.mu = compute_mu_prod(pnet.CPD{pnet.equiv_class(n)}, n, ps, msg,ns);

%'----------------------Distribute evidence ------------------'

% Send messages from root to leaves
for i=1:N
  n = engine.preorder(i);
  below = children(engine.adj_mat, n);
  msg = send_msgs_to_some_neighbors(n, msg, below, pnet, ...
				    engine.child_index, engine.parent_index, do_scaling);
end

%'----------------------MARGINALIZATION + NORMALIZATION ------------------'

engine.marginal = cell(1,N);
for n=1:N
   bel_jointe=msg{n}.mu .* msg{n}.lambda; 
   %[bel_conditionnelle] = normalise_prod(bel_jointe);     
   %engine.marginal{n} = bel_conditionnelle;
   engine.marginal{n} = bel_jointe;


end

engine.evidence = evidence; % needed by marginal_nodes and marginal_family
engine.msg = msg; % needed by marginal_family

%%%%%%%%%%

function msg = send_msgs_to_some_neighbors(n, msg, valid_nbrs, pnet, ...
						  child_index, parent_index, do_scaling)


%'==================Function send_msgs_to_some_neighbors============================='

%ces messages peuvent etre lambda ou mu

verbose = 0;

ns = pnet.node_sizes;
dag = pnet.dag;
e = pnet.equiv_class(n);
CPD = pnet.CPD{e};

cs = children(dag, n);
msg{n}.lambda = compute_lambda(n, cs, msg);

if verbose, fprintf('%d computes lambda\n', n); disp(msg{n}.lambda); end

ps = parents(dag, n);
msg{n}.mu = compute_mu_prod(CPD, n, ps, msg,ns);

if verbose, fprintf('%d computes mu\n', n); disp(msg{n}.mu); end

%'lambda from child'
ps2 = myintersect(parents(dag, n), valid_nbrs);
for p=ps2(:)'
   
  lam_msg = compute_lambda_msg_prod(CPD, n, ps, msg, p,ns);
  j = child_index{p}(n); % n is p's j'th child
  msg{p}.lambda_from_child{j} = lam_msg(:);
  if verbose, fprintf('%d sends lambda to %d\n', n, p); disp(lam_msg); end
end

%'mu_from_parent'
cs2 = myintersect(cs, valid_nbrs);
for c=cs2(:)'
  mu_msg = compute_mu_msg(n, cs, msg, c);
  j = parent_index{c}(n); % n is c's j'th parent
  msg{c}.mu_from_parent{j} = mu_msg;
  if verbose, fprintf('%d sends mu to %d\n', n, c); disp(mu_msg); end
end

%%%%%%%

function lambda = compute_lambda(n, cs, msg)
lambda = prod_lambda_msgs(n, cs, msg);

%%%%%%%

function mu_msg = compute_mu_msg(n, cs, msg,  c)
mu_msg = msg{n}.mu .* prod_lambda_msgs(n, cs, msg, c);


%%%%%%%%%

function lam = prod_lambda_msgs(n, cs, msg, except)

if nargin < 4, except = -1; end

lam = msg{n}.lambda_from_self(:);
for i=1:length(cs)
  c = cs(i);
  if c ~= except %les produits des lambda from parents sauf à celui à qui on va envoyé et il s'appelle except
    lam = lam .* msg{n}.lambda_from_child{i};
  end
end   


