function [clpot, modif_pot]=stabilize_two_neighbors(pnet, engine,  clpot, C, ns)

%This procedure ensures for each cluster having at least two neighbors its stability with
%respect to each pair of neighbors. Given a pair of neighbors, the cluster
%potential is modified using the procedure newpot_n_neighbors.

%'----------------------------------------------------------------------------------------------------------------------------'


modif_pot=0;
i=1;

while (i<=C) & (modif_pot==0)       %to treat all clusters
    
    %'---------------------------detect neighbors---------------------------'
    
 neighbors=[];
    for j=1:C
        
        if i~=j
            
           [inter_neighbors, val_intersect]=verif_intersection(clpot{i},clpot{j});
           
           if inter_neighbors==1
                neighbors=myunion(neighbors,j); 
            end
        end
    end


    
    %----------------------------------------------------------------------
    
    if length(neighbors)>=2         %stabilize at two neighbors is useless with clusters having less then two neighbors
       for j=1: (length(neighbors)-1) 
          first_neighbor=neighbors(j);
          for k=(j+1):(length(neighbors)) 
              second_neighbor=neighbors(k);
              two_neighbors=myunion(first_neighbor, second_neighbor);
              %[clpot{i},modif_pot]=fast_newpot_n_neighbors(clpot{i}, clpot, two_neighbors, ns);
              [clpot{i},modif_pot]=newpot_n_neighbors(clpot{i}, clpot, two_neighbors, ns);
              
              
                  
          end
       end
    end
    i=i+1;
 end
 
 


