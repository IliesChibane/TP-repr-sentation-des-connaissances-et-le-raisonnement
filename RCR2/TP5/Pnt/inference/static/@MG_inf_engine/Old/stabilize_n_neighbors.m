function [clpot, modif_pot]=stabilize_n_neighbors(pnet, engine,  clpot, C, ns)

modif_pot=0;
i=1;


while (i<=C) & (modif_pot==0)
      neighbors=[];
    
      %%ps=parents(pnet.dag,i);
      %cs=children(pnet.dag,i);
      %neighbors=myunion(ps,cs); 
      %%neighbors=ps;
      
      
       %neighbors=[];
    for j=1:C
        
        if i~=j
            
            [inter_neighbors, val_intersect]=verif_intersection(clpot{i},clpot{j});
           
           if inter_neighbors==1
                neighbors=myunion(neighbors,j); 
           end
       end
   end

    
    if length(neighbors)>1
     
       [clpot{i}, modif_pot]=newpot_n_neighbors(clpot{i}, clpot, neighbors, ns);
       
    end
    i=i+1;
 end
 
 
 


