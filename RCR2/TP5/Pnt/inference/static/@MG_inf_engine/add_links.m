function [engine, pnet, clpot, modif_pot, cap_max]=add_links(engine, pnet,   ns, ps, clpot, p, q, parent_index, pot_parents,alpha)

%add nodes to the cluster q

%'----------------------------------------------------------------------------------------------------------------------------'



        modif_pot=0;
        added=[]; 						% for added parents
      
      	for j=1:length(ps)
         	if j ~= parent_index     	% to avoid that the node appears in the list of its parents
            	added=[added ps(j)];
           		pnet.dag(ps(j),p)=1;  	% modification of parents in the DAG
         	end
      	end
      
      	if ~isempty(added)
            
            [clpot{q}, cap_max]=update_cluster_potential(clpot{q},added,ns); %add parents to cluster q
            
            if cap_max==0
                
            engine.clusters{q}=union(engine.clusters{q},added); %modify the cluster in the moral graph
            
            for a=1:length(pnet.nodes)-1
               for b=(a+1):length(pnet.nodes)
                   inter=intersect(engine.clusters{a}, engine.clusters{b});
                   if ~isempty(inter)
                       engine.separators{a,b}=inter;                       
                   end
               end
           end
           
               
               
            %'------------------------------- Recuperation of beta -----------------------------'   

            % the recuperation of beta is done in the cluster q (parent cluster of in_cl)
            % this is true when we add links (since we do it in this cluster) 
            % however if the parents are already linked this is useless since the clusters are stable and thus beta exists in the parent cluster

            [clpot{q},modif_pot]=compute_new_potential(clpot{q},pot_parents,ns);
            end
                 
      	end; %if
        
        
