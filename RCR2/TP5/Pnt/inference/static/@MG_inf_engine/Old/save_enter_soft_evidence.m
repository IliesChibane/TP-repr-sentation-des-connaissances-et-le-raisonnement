function [engine, pnet, Bel_evidence,clpot] = enter_soft_evidence(engine,  pnet, potential, evidence,  ck_cst, neighbor)

% ENTER_SOFT_EVIDENCE Add the specified potentials to the network (jtree)
% We denote by clpot: cluster potential
%             seppot: separator potential
% cluster(i): contains the cluster number corresponding to node i 


%'==============================BEGIN INITIALIZATION=============================='

ns = pnet.node_sizes(:);
C=length(engine.clusters); 		% number of clusters
clpot = cell(1, C);					% Set the cluster potentials to all 1s

for i=1:C								% fixes the domain and size of each potential 
 clpot{i} = mk_initial_pot_d(engine.clusters{i}, ns);
end

cluster=engine.clq_ass_to_node;  %cluster{i} contains the cluster number corresponding to node i
for i=1:length(cluster) 			% initialize clusters potentials
   c = cluster(i);
   clpot{c} = minimize_by_pot(clpot{c}, potential{i});
end

% incorporate evidence

var_evidence=find(~isemptycell(evidence));

for i=1:length(var_evidence)
  cl_var_evidence=engine.clq_ass_to_node(var_evidence(i))  ;
  [clpot{cl_var_evidence}]=incorporate_instance(clpot{cl_var_evidence},var_evidence(i), evidence{var_evidence(i)},ns);     
end


%'==============================BEGIN PROPAGATION=============================='


if ck_cst==1
    
global_consistency=0;				% test of global consistency

passage=0;

while  global_consistency==0
   
   passage=passage+1;
   
   if passage>1
      val_alpha= alpha_stable;
   end
  
%'==============================STABILIZATION=============================='

[clpot,alpha_stable]=stabilize(pnet,engine, clpot, C,ns,neighbor);

sortie_stab=alpha_stable

if (passage>1) 
   if alpha_stable==val_alpha;
      global_consistency=1;
  end
   
end

if global_consistency==0
   [engine,pnet, clpot, global_consistency, alpha_consistency]=check_consistency(engine, pnet,  clpot, C, alpha_stable, ns);
end


end  %end while

val_test=test_global_consistency(engine, pnet,  clpot, C, alpha_stable)

%'--------------------------------------------------------------------------------'

engine.clpot=clpot;

Bel_evidence=alpha_consistency;

else 
    
[clpot,alpha_stable]=stabilize(pnet,engine, clpot, C,ns,neighbor);

engine.clpot=clpot;

Bel_evidence=alpha_stable;

end



