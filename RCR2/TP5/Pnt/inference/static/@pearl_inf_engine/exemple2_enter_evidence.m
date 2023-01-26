function [engine, loglik] = enter_evidence(engine, evidence)
% ENTER_EVIDENCE Add the specified evidence to the network (pearl)
% [engine, loglik] = enter_evidence(engine, evidence)
% evidence{i} = [] if if X(i) is hidden, and otherwise contains its observed value (scalar or column vector)
%
% The loglik return value will only be correct if all CPDs are tabular.

bnet = bnet_from_engine(engine);
N = length(bnet.dag);
ns = bnet.node_sizes(:);

% Remarks on scaling
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
% to compute the likelihood. Also, scaling makes cutset conditioning harder (which was the whole
% motivation for the Peot and Shachter paper).

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

'message apres init'
l1=msg{1}.lambda 
p1=msg{1}.pi
l2=msg{2}.lambda 
p2=msg{2}.pi
l3=msg{3}.lambda 
p3=msg{3}.pi


% Send messages from leaves to root
for i=1:N-1
 n = engine.postorder(i);
 above = parents(engine.adj_mat, n);

 msg = send_msgs_to_some_neighbors(n, msg, above, bnet, ...
     engine.child_index, engine.parent_index, do_scaling);
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
  msg = send_msgs_to_some_neighbors(n, msg, below, bnet, ...
				    engine.child_index, engine.parent_index, do_scaling);
end

         
engine.marginal = cell(1,N);
for n=1:N
   [bel, lik] = normalise(msg{n}.pi .* msg{n}.lambda);     
   engine.marginal{n} = bel;
end

'bel apres normalize'

bel1=engine.marginal{1}
bel2=engine.marginal{2}
bel3=engine.marginal{3}
bel4=engine.marginal{4}
bel5=engine.marginal{5}
bel6=engine.marginal{6}

engine.evidence = evidence % needed by marginal_nodes and marginal_family
engine.msg = msg % needed by marginal_family
loglik = log(lik)

 
%%%%%%%%%%

function msg = send_msgs_to_some_neighbors(n, msg, valid_nbrs, bnet, ...
						  child_index, parent_index, do_scaling)

'Function send_msgs_to_some_neighbors============================================'
%ces messages peuvent etre lambda ou pi


n_de_send_msg=n

verbose = 0;

ns = bnet.node_sizes;
dag = bnet.dag;
e = bnet.equiv_class(n);
CPD = bnet.CPD{e};


cs = children(dag, n);
msg{n}.lambda = compute_lambda(n, cs, msg);

msg_n_lambda_dans_send_msg=msg{n}.lambda

if verbose, fprintf('%d computes lambda\n', n); disp(msg{n}.lambda); end

ps = parents(dag, n);
msg{n}.pi = compute_pi(CPD, n, ps, msg);

msg_n_pi_dans_send_msg=msg{n}.pi

if verbose, fprintf('%d computes pi\n', n); disp(msg{n}.pi); end

'lambda from child'
ps2 = myintersect(parents(dag, n), valid_nbrs);
for p=ps2(:)'
   
   lam_msg = compute_lambda_msg(CPD, n, ps, msg, p);
   lam_msg_avant_normalize=lam_msg(:)  
   
   if do_scaling, lam_msg = normalise(lam_msg); end
  
  lam_msg_apres_normalize=lam_msg(:)
  
  j = child_index{p}(n); % n is p's j'th child
  msg{p}.lambda_from_child{j} = lam_msg(:);
  if verbose, fprintf('%d sends lambda to %d\n', n, p); disp(lam_msg); end
end

'pi_from_parent'
cs2 = myintersect(cs, valid_nbrs);
for c=cs2(:)'
   pi_msg = compute_pi_msg(n, cs, msg, c);
   
   pi_msg_avant_normalize=pi_msg(:)  

if do_scaling, pi_msg = normalise(pi_msg); end

   pi_msg_apres_normalize=pi_msg(:)  

  j = parent_index{c}(n); % n is c's j'th parent
  msg{c}.pi_from_parent{j} = pi_msg;
  if verbose, fprintf('%d sends pi to %d\n', n, c); disp(pi_msg); end
end



%%%%%%%

function lambda = compute_lambda(n, cs, msg)
% Pearl p183 eq 4.50
lambda = prod_lambda_msgs(n, cs, msg);

%%%%%%%

function pi_msg = compute_pi_msg(n, cs, msg,  c)
% Pearl p183 eq 4.53 and 4.51
msg_n_pi=msg{n}.pi
pi_msg = msg{n}.pi .* prod_lambda_msgs(n, cs, msg, c);

%%%%%%%%%

function lam = prod_lambda_msgs(n, cs, msg, except)

if nargin < 4, except = -1; end

lam = msg{n}.lambda_from_self(:);
for i=1:length(cs)
  c = cs(i);
  if c ~= except %les produits des lambda from parents sauf à celui à qui on va envoyé et il s'appelle except
    lambda_from_child_sauf_except=msg{n}.lambda_from_child{i}
    lam = lam .* msg{n}.lambda_from_child{i};
  end
end   
resultat_de_prod_lambda_msgs=lam
