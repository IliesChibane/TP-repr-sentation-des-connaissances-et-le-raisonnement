function [engine, pnet, Bel_instance,clpot, cap_max,nb_add] = enter_instance(engine,  pnet, potential, instance,  ck_cst, nb_nodes,nodes_type,nb_add)

% ENTER_SOFT_instance Add the specified potentials to the network (jtree)
% We denote by clpot: cluster potential
%             seppot: separator potential
% cluster(i): contains the cluster number corresponding to node i 


%'==============================BEGIN INITIALIZATION=============================='

ns = pnet.node_sizes(:);
C=length(engine.clusters); 		% number of clusters

clpot = cell(1, C);					% Set the cluster potentials to all 1s
clpot=potential;    %the initial joint distributions are equal to the initial conditional ones

%for i=1:C								% fixes the domain and size of each potential 
% clpot{i} = mk_initial_pot_d(engine.clusters{i}, ns);
% affiche(clpot{i})
%end

%cluster=engine.clq_ass_to_node  %cluster{i} contains the cluster number corresponding to node i
%for i=1:length(cluster) 			% initialize clusters potentials
%   c = cluster(i);
%   clpot{c} = minimize_by_pot(clpot{c}, potential{i});
%end

% -----------------------------incorporate instance-----------------------------


if ~isempty(find(~isemptycell(instance))) 
    
var_instance=find(~isemptycell(instance));

for i=1:length(var_instance)
 
  cl_var_instance=engine.clq_ass_to_node(var_instance(i))  ;
  [clpot{cl_var_instance}]=incorporate_instance(clpot{cl_var_instance},var_instance(i), instance{var_instance(i)},ns);     
end

end


%'==============================BEGIN PROPAGATION=============================='


if ck_cst==1
    
global_consistency=0;				% test of global consistency
cap_max=0;

while  global_consistency==0 & (cap_max==0) 	
   
[clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns,nb_nodes,nodes_type);


[engine,pnet, clpot, global_consistency, alpha_consistency, cap_max,nb_add]=check_consistency_add_links(engine, pnet,  clpot, C, alpha_stable, ns,nb_add);


end  %end while

%'--------------------------------------------------------------------------------'

Bel_instance=alpha_consistency;

else
   
if  ck_cst==2
    
global_consistency=0;				% test of global consistency
cap_max=0;
nb_add=0;

while  global_consistency==0 & (cap_max==0) 	
   
[clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns,nb_nodes,nodes_type);

[engine,clpot,global_consistency, alpha_consistency]=check_consistency_gl_instances(engine,  clpot, alpha_stable, C);

end  %end while

%'--------------------------------------------------------------------------------'

Bel_instance=alpha_consistency;

else
   
[clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns,nb_nodes,nodes_type);

Bel_instance=alpha_stable;

end

end

engine.clpot=clpot;

    