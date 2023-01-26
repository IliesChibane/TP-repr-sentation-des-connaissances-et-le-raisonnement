function [engine,pnet, clpot, global_consistency, alpha_consistency, cap_max,nb_add]=check_consistency_add_links(engine, pnet,  clpot, C, alpha_stable,ns,nb_add)


%This procedure ensures the global consistency by computing from each cluster having at least one
%parent the potential of its parents (i.e. \emph{pot\_parents}).
%\\ Then,  we check if this distribution contains some values less
%than \emph{alpha-stable} using \emph{check\_consistency\_cluster}.
%If so,  then the cluster is inconsistent. In this case we should
%first test the following situations before dropping its
%inconsistency:
%- if the degree $\beta$ exists in the parents of $C_i$ (this test is performed using \emph{check\_beta}),
%- if the parents of the treated cluster are already linked in the DAG (i.e. \emph{all\_linked}=0) (from the construction or from additional links of a previous step).

%If none of these cases is true, then we should modify the
%inconsistent cluster as follows:
%* Modification of the potential of the inconsistent cluster (replace \emph{beta} by \emph{alpha-stable} using \emph{modify\_pot})
%* Retrieval of \emph{beta} by adding links between parents of\emph{i} (i.e. \emph{ps}) using \emph{add\_links}. To do so, we
%choose the parent in the maximum position (i.e.
%\emph{parent\_index}) and transform the other parents (i.e.
%\emph{rest\_parents}) as its parents in its corresponding cluster
%(i.e. \emph{q}) so that to respect the topological order.

%Note that this consistency procedure starts from the leaves clusters until reaching the roots (i.e. from cluster number C down to number 1).
%'----------------------------------------------------------------------------------------------------------------------------'

global_consistency=1;
cap_max=0;

i=C;  % C is the number of clusters i.e we test leafs clusters first. Note that the number of clusters is equal to the number of ps

while (global_consistency==1) & (i >= 1) & (cap_max==0) 	 		
    
    ps=[]; %contains the neighbors of i

    ps=parents(pnet.dag, i); 
    
       if  length(ps)>1  % test consistency is useless for roots and for nodes having just one parent since we cant add links in the latter case
         
       pot_parents = [];
       
       pot_parents=marginalize_pot(clpot{i}, ps); %compute the potential of ps and save beta before changing the potential
       
       consistency=  check_consistency_cluster(C,pot_parents,alpha_stable);
      
       if (consistency==0)  

            modif_pot=0; %to mark any modification in the potentials of parents clusters
 
%'---------------2) verification of the degree beta-------------------------------------------------------'            
            
            test_beta=1;
            
            [test_beta, cap_max]=  very_fast_check_beta(pot_parents,clpot, ns, ps,alpha_stable);
            
            if cap_max==0       %we dont reach teh maximal capacity
            
            if  test_beta==0    %the degree beta does not exits
                
                

%'---------------3) Add links between parents in inconsistent cluster---------'   

% adding parents is not performed if we are in one of these two cases:
% a) the node has just one parent
% b) the parent's node are already linked in the DAG (from the construction or from additional links of a previous step)

% if we are not in any of these cases:
% we choose the parent with the maximum position and transform the other parents as is parents
% so that to respect the condition that the the position of the parents is less than their children

            [parent_value parent_index]= max(ps);  %search the position of the max parents
      
            p=ps(parent_index); 
            
            q=engine.clq_ass_to_node(p); 			 %cluster in which we will add parents if necessary

%'---------------------verification of the case (a)----------------------'

% if the parents are linked this means that p is the child of the rest of parents of the node relative to in_cl

            rest_parents=setdiff(ps,p);     %parents of the node relative to in_cl except p

            pp=parents(pnet.dag,p); 	 	%parents of the node p (from the DAG)

            all_linked=0;				 	%we suppose that all parents are not linked
      
            %test if parents are already linked
            if length(ismember(rest_parents,pp))==sum(ismember(rest_parents,pp))  %since ismember(rest_parents,pp) contains 0 or 1
                all_linked=1;
            end
      
      %-----------------------Effective change---------------------------------'
      
            if (all_linked==0)
                
                %'---------------1) Modification of the potential of the inconsistent cluster (replace beta by alpha)-----'
    
                clpot{i}=very_fast_modify_pot(clpot{i}, ps, alpha_stable,ns);  %faster than modify_pot

                %'---------------------------------------Add links--------------------------------------'

                [engine, pnet, clpot, modif_pot, cap_max]=add_links(engine, pnet,  ns, ps,  clpot, p, q, parent_index, pot_parents,alpha_stable);
                nb_add=nb_add+1;
           
                if (modif_pot==1)  | (cap_max==1) % for any modification we should exit the loop and restabilize
                    global_consistency=0;
                end
                                 
            end 

        end %if cap max
        
        end %if test beta
            
        end  %if consistency==0
        
    end %if length(ps)>1

%'----------------------------------------------------------------------------------'   

 i=i-1;
 
  
end %while

alpha_consistency=maximum_value(clpot{1},C);



