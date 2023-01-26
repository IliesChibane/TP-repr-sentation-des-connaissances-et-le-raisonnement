function [clpot, modif_pot]=stabilize_two_neighbors(pnet, engine,  clpot, C, ns)



modif_pot=0;
i=1;

while (i<=C) & (modif_pot==0)       %to treat all clusters
    
    
    %'---------------------------detect neighbors---------------------------'
    
   ps=parents(pnet.dag,i)
   %cs=children(pnet.dag,i);
   %neighbors=myunion(ps,cs); 
   neighbors=ps;

    %----------------------------------------------------------------------
    
    if length(neighbors)>=2         %stabilize at two neighbors is useless with clusters having less then two neighbors
       for j=1: (length(neighbors)-1) 
          first_neighbor=neighbors(j);
          for k=(j+1):(length(neighbors)) 
              second_neighbor=neighbors(k);
              two_neighbors=myunion(first_neighbor, second_neighbor);
              % [clpot{i},modif_pot]=fast_newpot_n_neighbors(clpot{i}, clpot, two_neighbors, ns);
              [clpot{i},modif_pot]=newpot_n_neighbors(clpot{i}, clpot, two_neighbors, ns);
              
             %modif_pot indicatres if there is a modification when stabilizing  clpot{i} w.r.t two_neighbors
             %if any cluster is modified we exist this procedure and restabilize the moral graph at one-neighbor
              
          end
       end
    end
    i=i+1;
 end
 
 
 
 


