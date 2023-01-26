function msg =  init_msgs(dag, ns, evidence, rand_init)
% INIT_MSGS Initialize the lambda/mu message and state vectors
% msg =  init_msgs(dag, ns, evidence, rand_init)
%
% We assume all the nodes are discrete.
% The initial values of the msgs don't matter in the distributed version, since they "wash out".
% In the centralized version, they should be set to 1s.

if nargin < 4, rand_init = 0; end

N = length(dag);
msg = cell(1,N);
observed = ~isemptycell(evidence);

for n=1:N
  ps = parents(dag, n);
  msg{n}.mu_from_parent = cell(1, length(ps));
  for i=1:length(ps)
    p = ps(i);
    if rand_init
      msg{n}.mu_from_parent{i} = rand(ns(p), 1);
    else
      msg{n}.mu_from_parent{i} = ones(ns(p), 1);
    end
  end
  
  cs = children(dag, n);
  msg{n}.lambda_from_child = cell(1, length(cs));
  for i=1:length(cs)
    c = cs(i);
    if rand_init
      msg{n}.lambda_from_child{i} = rand(ns(n), 1);
    else
      msg{n}.lambda_from_child{i} = ones(ns(n), 1);
    end
  end

  if rand_init
    msg{n}.lambda = rand(ns(n), 1);
    msg{n}.mu = rand(ns(n), 1);
  else
    msg{n}.lambda = ones(ns(n), 1);
    msg{n}.mu = ones(ns(n), 1);
  end
  
  % Initialize the lambdas with any evidence
  if observed(n)
    v = evidence{n};
    msg{n}.lambda_from_self = zeros(ns(n), 1);
    msg{n}.lambda_from_self(v) = 1; % delta function
  else
    msg{n}.lambda_from_self = ones(ns(n), 1);
  end
end
