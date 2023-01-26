function [clpot, modif_pot]=stabilize_three_neighbors(pnet, engine,  clpot, C, ns)

modif_pot=0;
i=1;

while (i<=C) & (modif_pot==0)       %to trat all clusters
    %neighbors=[];
    %for j=1:C
        
    %    if i~=j
            
    %        [inter_neighbors, val_intersect]=verif_intersection(clpot{i},clpot{j});
           
    %       if inter_neighbors==1
    %            neighbors=myunion(neighbors,j); 
    %       end
    %    end
    %end
    
   ps=parents(pnet.dag,i);
   %cs=children(pnet.dag,i);
   %neighbors=myunion(ps,cs); 
   neighbors=ps;

    if length(neighbors)>=3         %stabilize at three neighbors is useless with clusters having less then three neighbors
       for j=1: (length(neighbors)-2) 
          first_neighbor=neighbors(j);
          for k=(j+1):(length(neighbors)-1) 
              second_neighbor=neighbors(k);
              for l=(k+1):(length(neighbors)) 
              third_neighbor=neighbors(l);    
              three_neighbors=myunion(first_neighbor, myunion(second_neighbor, third_neighbor));
 		      [clpot{i},modif_pot]=newpot_n_neighbors(clpot{i}, clpot, three_neighbors, ns);
              end
          end
       end
    end
    i=i+1;
 end
 
 


