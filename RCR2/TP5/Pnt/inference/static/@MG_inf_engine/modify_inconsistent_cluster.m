function [engine, bnet, clpot, modif_pot]=modify_inconsistent_cluster(engine, bnet,  in_cl, clpot, alpha_stable, ns,  C)


%'---------------1) Modification of the potential of the inconsistent cluster (replace beta by alpha)-----'
   
   
   
    ps =  parents(bnet.dag,in_cl);   
    
    pot_parents=marginalize_pot(clpot{in_cl}, ps);  %save beta before changing the potential
    
    clpot{in_cl}=modify_pot(clpot{in_cl},ps,alpha_stable);
    
    %'affichage du potentiel modifie'
    % affiche(clpot{in_cl})
     
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

      pp=parents(bnet.dag,p); 	 	%parents of the node p (from the DAG)

      all_linked=0;				 	%we suppose that all parents are not linked
      
      if length(ismember(rest_parents,pp))==sum(ismember(rest_parents,pp))  %since ismember(rest_parents,pp) contains 0 or 1
         all_linked=1;
      end
      
      %-----------------------Add links ---------------------------------'
      
       
      if (length(ps) >1) & (all_linked==0)
         
      [engine, bnet, clpot, modif_pot]=add_links(engine, bnet,  ns, ps, C, clpot, p, q, parent_index, pot_parents);

                                       
      end %if
