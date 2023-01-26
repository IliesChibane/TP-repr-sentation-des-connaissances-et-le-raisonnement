function [clpot, one_neighbor_consistency]=check_consistency_one_neighbor(engine, pnet,  clpot, C, alpha_stable, ns)

pot_parents = cell(C, C);
inconsistent_set=[];  	% Inconsistant_set contains all informations about inconsistent clusters 
inconsistent_cluster.cluster=[];
one_neighbor_consistency=0;

%ONE NEIGHBOR

for i=C:-1:1   %1			% we test leafs clusters first 
   ps =  parents(pnet.dag,i);   
      
   if  ~isempty(ps) %2 % test consistency is useless for roots
   
       cl=engine.clq_ass_to_node(i); %the cluster assigned to node i
       
       inconsistent_cluster.parent=[];
      	
       for j=1:length(ps)  %3  %treat parents one by one
       
       pot_parents{j}=marginalize_pot(clpot{cl}, ps(j));
      	
      % je marginalize le potentiel de chaque cluster sur les parents du noeud un à un
    	% Apres, pour tester la consistance il suffit de voire s'il ya une valeur inferieure à alpha
   
       consistency=1; 
   
       consistency=  check_consistency_cluster(C,pot_parents{j},alpha_stable,consistency);
         
       if (consistency==0)  
            inconsistent_cluster.parent=[inconsistent_cluster.parent ps(j)];  %contains inconsistent parents
       end 
         
       end  %3
       
       if ~isempty(inconsistent_cluster.parent)
          inconsistent_cluster.cluster=cl;     	
          inconsistent_set=[inconsistent_set inconsistent_cluster];

       end
       
      
   end  %2
 end  %1
  
 if isempty(inconsistent_set)  %all clusters are consitent locally at one neighbor
    
    one_neighbor_consistency=1;
     
 else     
    
    modif_pot=0;
    
    nb_inconsistent_clusters=length(inconsistent_set); 
    
    pot_parents = cell(nb_inconsistent_clusters, nb_inconsistent_clusters);
    
    for i=1:nb_inconsistent_clusters
   
   %'--------------- Modification of the potential of the inconsistent cluster (replace beta by alpha)-----'
   
   in_cl=inconsistent_set(i).cluster;

   for j=1:length(inconsistent_set(i).parent)
    
    	pot_parents{j}=marginalize_pot(clpot{in_cl}, inconsistent_set(i).parent(j));  %save beta before changing the potential
    
    	clpot{in_cl}=modify_pot(clpot{in_cl},inconsistent_set(i).parent(j),alpha_stable,ns);
       
   %'------------------------------- Recuperation of beta -----------------------------'   

	    q=engine.clq_ass_to_node(inconsistent_set(i).parent(j)); 			
       
   	 [clpot{q},modif_pot]=compute_new_potential(clpot{q},pot_parents{j},ns);
   end
 
end  %for of the modification

if (modif_pot==0) 
         one_neighbor_consistency=1;
end
      
end