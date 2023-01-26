function [engine, pnet, Bel_Cdt] = enter_var_interest(engine,  pnet,  var_interest, ck_cst, neighbor)

ns = pnet.node_sizes(:);

nb_instance=ns(var_interest);      
   
cl_var_interest=engine.clq_ass_to_node(var_interest);

Bel_joint=dpot(var_interest,ns(var_interest));

sauv_engine=engine;   
sauv_pnet=pnet;

%incorporate each instance of the variable of interest

for instance=1:nb_instance %1
    
      engine=sauv_engine;
      clpot=engine.clpot;   
      pnet=sauv_pnet; 
      
      ns = pnet.node_sizes(:);

      C=length(engine.clusters); 		% number of clusters

      [clpot{cl_var_interest}]=incorporate_instance(clpot{cl_var_interest},var_interest,instance,ns); 
      
 
if ck_cst==1 %2
    
global_consistency=0;				% test of global consistency

while  global_consistency==0 %3
    
[clpot,alpha_stable]=stabilize(pnet,engine, clpot, C,ns, neighbor);

[engine,pnet, clpot, global_consistency, alpha_consistency]=check_consistency(engine, pnet,  clpot, C, alpha_stable,ns);

end %3

[Bel_joint] =  affect_val(Bel_joint,instance, alpha_consistency);


else 
    [clpot,alpha_stable]=stabilize(pnet,engine, clpot, C,ns, neighbor);
    
    [Bel_joint] =  affect_val(Bel_joint,instance, alpha_stable);
   
   
end%2

end % 1

engine.clpot=clpot;

  
%  =========================  Normalization =========================

[Bel_Cdt_big] = normalize_pot(Bel_joint);
   
Bel_Cdt=affect_T(Bel_Cdt_big);
   
   
