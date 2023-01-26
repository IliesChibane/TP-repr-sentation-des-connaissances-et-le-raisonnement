function [clpot] = enter_soft_evidence(engine,  potential, onodes)
% ENTER_SOFT_EVIDENCE Add the specified potentials to the network (jtree)
% [clpot, loglik] = enter_soft_evidence(engine, cluster, potential, onodes)
%
% We return the modified engine and all the cluster potentials.
% We denote by clpot: cluster potential
%             seppot: separator potential

pnet = pnet_from_engine(engine);
N = length(pnet.dag);
ns = pnet.node_sizes(:);
cluster=engine.clq_ass_to_node;

%'-----------------------------INITIALIZATION-----------------------------'

% Set the cluster potentials to all 1s
C = length(engine.clusters); %nombre de clusters
clpot = cell(1, C);

for i=1:C
   clpot{i} = mk_initial_pot_d(engine.clusters{i}, ns, onodes);
end

% Minimize on specified potentials
% cluster(i) contains the lighest cluster corresponding to node i
for i=1:length(cluster)
  c = cluster(i);
  clpot{c} = multiply_by_pot(clpot{c}, potential{i});
 
end


seppot = cell(C, C);
% separators are implicitely initialized to 1s

%'-----------------------------COLLECT EVIDENCE-----------------------------'

% collect to root (node to parents)
for n=engine.postorder(1:end-1)
  for p=parents(engine.jtree, n)
    seppot{p,n} = marginalize_pot(clpot{n}, engine.separator{p,n});
    clpot{p} = multiply_by_pot(clpot{p}, seppot{p,n});
  end
end

%'-----------------------------DISTRIBUTE EVIDENCE-----------------------------'

% distribute from root (node to children)
for n=engine.preorder
   for c=children(engine.jtree, n)
    clpot{c} = divide_by_pot(clpot{c}, seppot{n,c});
    seppot{n,c} = marginalize_pot(clpot{n}, engine.separator{n,c});
    clpot{c} = multiply_by_pot(clpot{c}, seppot{n,c});
  end
end

%'-----------------------------NORMALIZATION----------------------------'

%for i=1:C
%      [clpot{i}] = normalize_pot_prod(clpot{i});
%end
   
%'-----------------------------FIN PROPAGATION-----------------------------'

