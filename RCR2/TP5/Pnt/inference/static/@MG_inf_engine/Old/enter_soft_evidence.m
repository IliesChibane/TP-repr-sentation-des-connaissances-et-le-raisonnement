function [clpot, loglik] = enter_soft_evidence(engine, clique, potential, onodes, pot_type)
% ENTER_SOFT_EVIDENCE Add the specified potentials to the network (jtree)
% [clpot, loglik] = enter_soft_evidence(engine, clique, potential, onodes, pot_type)
%
% We multiply potential{i} onto clique(i) before propagating.
% We return the modified engine and all the clique potentials.

bnet = bnet_from_engine(engine);
ns = bnet.node_sizes(:);
cnodes = bnet.cnodes;

% Set the clique potentials to all 1s
C = length(engine.cliques);
clpot = cell(1, C);
for i=1:C
  clpot{i} = mk_initial_pot(pot_type, engine.cliques{i}, ns, cnodes, onodes);
end

% Multiply on specified potentials
for i=1:length(clique)
  c = clique(i);
  clpot{c} = multiply_by_pot(clpot{c}, potential{i});
end

for i=1:C
  fprintf('init clpot{%d}\n', i); s=struct(clpot{i}); s.T
end

seppot = cell(C, C);
% separators are implicitely initialized to 1s

% collect to root (node to parents)
for n=engine.postorder(1:end-1)
  for p=parents(engine.jtree, n)
    %clpot{p} = divide_by_pot(clpot{n}, seppot{p,n}); % dividing by 1 is redundant
    %fprintf('clpot{%d}\n', n); s=struct(clpot{n}); s.T
    seppot{p,n} = marginalize_pot(clpot{n}, engine.separator{p,n});
    %fprintf('seppot{%d,%d}\n', p, n); s=struct(seppot{p,n}); s.T
    clpot{p} = multiply_by_pot(clpot{p}, seppot{p,n});
    %fprintf('clpot{%d}\n', p); s=struct(clpot{p}); s.T
  end
end

% distribute from root (node to children)
for n=engine.preorder
  for c=children(engine.jtree, n)
    clpot{c} = divide_by_pot(clpot{c}, seppot{n,c});
    seppot{n,c} = marginalize_pot(clpot{n}, engine.separator{n,c});
    clpot{c} = multiply_by_pot(clpot{c}, seppot{n,c});
  end
end

ll = zeros(1, C);
for i=1:C
  [clpot{i}, ll(i)] = normalize_pot(clpot{i});
end

loglik = ll(1); % we can extract the likelihood from any clique


