function [engine,pnet, clpot, global_consistency, alpha_consistency]=fast_check_consistency(engine, pnet,  clpot, C, alpha_stable,ns)

pot_parents = cell(C, C);
inconsistent_set=[];  	% Inconsistant_set will contain all informations about inconsistent clusters 
inconsistent_cluster.cluster=[];
global_consistency=0;

for i=C:-1:1   			% we test leafs clusters first 
   ps =  parents(pnet.dag,i);  
      
   if  ~isempty(ps)  % test consistency is useless for roots
   
       cl=engine.clq_ass_to_node(i); %the cluster assigned to node i
      	
       pot_parents{i}=marginalize_pot(clpot{cl}, ps); %compute the potential of ps
     	
       consistency=  check_consistency_cluster(C,pot_parents{i},alpha_stable);
         
       if (consistency==0)  
         	inconsistent_cluster.cluster=cl;
         	inconsistent_set=[inconsistent_set inconsistent_cluster];
	   end 
      
      end 
 end 
  
if isempty(inconsistent_set)  %all clusters are consitent locally
     global_consistency=1;
else     

%'==============================MODIFICATION=============================='

modif_pot=0; %to mark any modification in the potentials of parents clusters

nb_inconsistent_clusters=length(inconsistent_set); 

pot_parents = cell(nb_inconsistent_clusters, nb_inconsistent_clusters);

for i=1:nb_inconsistent_clusters
   
%'---------------1) Modification of the potential of the inconsistent cluster (replace beta by alpha)-----'
   
    in_cl=inconsistent_set(i).cluster;
    
    ps =  parents(pnet.dag,in_cl);   
    
    pot_parents{i}=marginalize_pot(clpot{in_cl}, ps);  %save beta before changing the potential
    
    %verif if beta exists in parents
    
    test_beta=
    
    
    
    
%    clpot{in_cl}=modify_pot(clpot{in_cl},ps,alpha_stable,ns);
    
    clpot{in_cl}=fast_modify_pot_n_neighbor(clpot{in_cl}, ps, alpha_stable,ns);  %faster than modify_pot
    
%'---------------2) Add links between parents in inconsistent cluster---------'   

% adding parents is not performed if we are in one of these two cases:
% a) the node has just one parent
% b) the parent's node are already linked in the DAG (from the construction or from additional links of a previous step)

% if we are not in any of these cases:
% we choose the parent with the maximum position and transform the other parents as is parents
% so that to respect the condition that the the position of the parents is less than their children

      [parent_value parent_index]= max(ps);  %search the parent in the max position
      
      p=ps(parent_index); 
            
      q=engine.clq_ass_to_node(p); 			 %parent cluster of in_cl

     %'---------------------verification of the case (a)----------------------'

     % if the parents are linked this means that p is the child of the rest of parents of the node relative to in_cl

      rest_parents=setdiff(ps,p);   %parents of the node relative to in_cl except p

      pp=parents(pnet.dag,p); 	 	%parents of the node p (from the DAG)

      all_linked=0;				 	%we suppose that all parents are not linked
      
      if length(ismember(rest_parents,pp))==sum(ismember(rest_parents,pp))  %since ismember(rest_parents,pp) contains 0 or 1
         all_linked=1;
      end
      
      %-----------------------Add links ---------------------------------'
       
      if (length(ps) >1) & (all_linked==0)
         
      [engine, pnet, clpot, modif_pot]=add_links(engine, pnet,  ns, ps, C, clpot, p, q, parent_index, pot_parents{i});
                                      
      end 
  
  end  

%'----------------------------------------------------------------------------------'   


 if (modif_pot==0) 
     global_consistency=1;
  end
  
end


alpha_consistency=maximum_value(clpot{1},C);



