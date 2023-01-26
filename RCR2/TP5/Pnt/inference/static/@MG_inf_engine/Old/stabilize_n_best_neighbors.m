function [clpot, modif_pot]=stabilize_n_neighbors(pnet, engine,  clpot, C, ns)

modif_pot=0;
i=1;


while (i<=C) & (modif_pot==0)
      neighbors=[];
    
      ps=parents(pnet.dag,i);
      %cs=children(pnet.dag,i);
      %neighbors=myunion(ps,cs); 
      neighbors=ps;

    
    if length(neighbors)>1
     
       [clpot{i}, modif_pot]=newpot_n_neighbors_min(clpot{i}, clpot, neighbors, ns);
       
    end
    i=i+1;
 end
 
 
 


