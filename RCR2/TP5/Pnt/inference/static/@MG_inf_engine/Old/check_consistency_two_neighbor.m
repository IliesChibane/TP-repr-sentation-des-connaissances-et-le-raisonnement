function [engine,pnet, clpot, two_neighbor_consistency]=check_consistency_two_neighbor(engine, pnet,  clpot, C, alpha_stable,ns)

pot_parents = cell(C, C);
inconsistent_set=[];  	% Inconsistant_set contains all informations about inconsistent clusters 
inconsistent_cluster.cluster=[];
two_neighbor_consistency=0;

%two NEIGHBOR


for i=C:-1:1   			% we test leafs clusters first 
   ps =  parents(pnet.dag,i);
   
   if  length(ps)>1  % test consistency is useless for nodes with one parent
      
       cl=engine.clq_ass_to_node(i); %the cluster assigned to node i
       
       inconsistent_cluster.parent=cell(0, 0);
       
       cpt=1;
             	
       for j=1:(length(ps)-1)  %we test variables one by one
          first_parent=ps(j);
          for k=(j+1):length(ps)
             
             second_parent=ps(k);
             parent_couple=[first_parent second_parent];
             pot_parents{j,k}=marginalize_pot(clpot{cl},parent_couple);
      	
      % je marginalize le potentiel de chaque cluster sur les parents du noeud un à un
    	% Apres, pour tester la consistance il suffit de voire s'il ya une valeur inferieure à alpha
   
   			consistency=1; 
   
   			consistency=  check_consistency_cluster(C,pot_parents{j,k},alpha_stable,consistency);
            
            if (consistency==0) 
                 inconsistent_cluster.parent{cpt}= parent_couple;  %couple of inconsistent parents
                 cpt=cpt+1;
            end 
         
          end  %for
          
       end	%for
 
       if ~isempty(inconsistent_cluster.parent)
          inconsistent_cluster.cluster=cl;     	
          inconsistent_set=[inconsistent_set inconsistent_cluster];

       end
       
   end %if length(ps)>1
end %for


if isempty(inconsistent_set)  %all clusters are consitent locally
   
     two_neighbor_consistency=1;
     
  else
     
     modif_pot=0; %to mark any modification in the potentials of parents clusters
     nb_inconsistent_clusters=length(inconsistent_set); 
     pot_parents = cell(nb_inconsistent_clusters, nb_inconsistent_clusters);
     
     for i=1:nb_inconsistent_clusters %1
   
   %'---------------1) Modification of the potential of the inconsistent cluster (replace beta by alpha)-----'
   
   	in_cl=inconsistent_set(i).cluster;

   	for j=1:length(inconsistent_set(i).parent)  %2
      
      	pot_parents{j}=marginalize_pot(clpot{in_cl}, inconsistent_set(i).parent{j});  %save beta before changing the potential
      
         clpot{in_cl}=modify_pot(clpot{in_cl},inconsistent_set(i).parent{j},alpha_stable,ns);
         
   %'---------------2) Add links between first_parent and second_parent------'   

% adding parents is not performed if first_parent and second_parent are already linked in the DAG (from the construction or from additional links of a previous step)
% if we are not in any of these cases, first_parent becomes the parent of second_parent so that to respect topological order

	      first_parent=inconsistent_set(i).parent{j}(1); 
      
   	   second_parent=inconsistent_set(i).parent{j}(2); 
      
      	q=engine.clq_ass_to_node(second_parent); 	

     %'---------------------verification of the link between fiurst and second parent----------------------'

	      pp=parents(pnet.dag,second_parent); 	 	%parents of the second_parent (from the DAG)

	      all_linked=0;				 	%we suppose that all parents are not linked
      
   	   if length(ismember(first_parent,pp))==sum(ismember(first_parent,pp))  %since ismember(rest_parents,pp) contains 0 or 1
      	   all_linked=1;
      	end
      
      %-----------------------Add links ---------------------------------'
      	if all_linked==0  %they are not linked 
         
         	[engine, pnet, clpot, modif_pot]=add_links_two_neighbors(engine, pnet, ns, C,clpot, q, first_parent, second_parent , pot_parents{j});
      
      	end 
   
   end %2
  
  end  %1

  if (modif_pot==0) 
     two_neighbor_consistency=1;
  end
  
  end
 
 
