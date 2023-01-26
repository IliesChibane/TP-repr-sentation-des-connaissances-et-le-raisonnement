function [clpot, modif_pot, cap_max]=n_nodes_stability(pnet, engine,  clpot, C, ns,nodes_type)

modif_pot=0;
cap_max=0;
nb=0;

i=1;

while (i<=C) & (modif_pot==0) & (cap_max==0)
    nodes=define_nodes(pnet.dag, engine, i, nodes_type, C);
    
    if length(nodes)>1
     
       [clpot{i}, modif_pot,cap_max]=newpot_n_nodes(clpot{i}, clpot, nodes, ns);
       
    end
    i=i+1;
    nb=nb+1;
    if nb  > 8000
       cap_max=1;
   end
 end
 

 %if cap_max==1
  %   'on a depassé la capacité'
 %end
 
 
 


