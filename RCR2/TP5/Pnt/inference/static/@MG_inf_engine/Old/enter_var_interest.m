function [engine, pnet, Bel_Cdt, cap_max,nb_add] = enter_var_interest(engine,  pnet,  var_interest, instance_interest, Bel_evidence,ck_cst, nb_nodes,nodes_type, nb_add)

ns = pnet.node_sizes(:);

cl_var_interest=engine.clq_ass_to_node(var_interest);

clpot=engine.clpot;

C=length(engine.clusters); 		% number of clusters

[clpot{cl_var_interest}]=incorporate_instance(clpot{cl_var_interest},var_interest,instance_interest,ns);       %incorporate the instance of interest
 
if ck_cst==1 %2
    
global_consistency=0;				% test of global consistency
cap_max=0;

while  global_consistency==0 & cap_max==0 %3

[clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns, nb_nodes,nodes_type);

[engine,pnet, clpot, global_consistency, alpha_consistency,cap_max,nb_add]=check_consistency_add_links(engine, pnet,  clpot, C, alpha_stable,ns,nb_add);

end %3

[clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns, nb_nodes,nodes_type);

Bel_Cdt = alpha_consistency; %si on modifie normalization il faut  Bel_evidence = alpha_consistency;
%normalization
%if alpha_consistency == Bel_evidence
%        Bel_Cdt=1;
%    else
%        Bel_Cdt = alpha_consistency;
%end

else
   
if  ck_cst==2
    
global_consistency=0;				% test of global consistency
cap_max=0;
nb_add=0;

while  global_consistency==0 & cap_max==0
   
[clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns,nb_nodes,nodes_type);

[engine,clpot,global_consistency, alpha_consistency, cap_max]=check_consistency_gl_instances(engine,  clpot, alpha_stable, C);

end  %end while

%'--------------------------------------------------------------------------------'

Bel_Cdt = alpha_consistency;
%normalization
%if alpha_consistency == Bel_evidence
%        Bel_Cdt=1;
%    else
%        Bel_Cdt = alpha_consistency;
%end


else 
    [clpot,alpha_stable, cap_max]=stabilize(pnet,engine, clpot, C,ns, nb_nodes,nodes_type);
    
    Bel_Cdt =  alpha_stable;
    
 end %2
 end

engine.clpot=clpot;

%normalization
%if alpha_stable == Bel_evidence
%    Bel_Cdt=1;
%else
%    Bel_Cdt =  alpha_stable;
%end

%---------------------------------------------------------------------------------'

%calcul jointe
%   inter=clpot{1};
%   for i=2:C
%      potcl=clpot{i};
%      inter=compute_joint(inter,potcl,ns);
%   end
   


   