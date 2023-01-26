function [engine, pnet, clpot, modif_pot]=add_links_two_neighbors(engine, pnet,   ns, C,clpot, q, first_parent, second_parent , pot_parents)

pnet.dag(first_parent,second_parent)=1;  	% modification of parents in the DAG

clpot{q}=add_parents_to_cluster(clpot{q},first_parent,ns); %add first_parent to cluster q
            
engine.clusters{q}=union(engine.clusters{q},first_parent); %modify the cluster in the moral graph
               
%updating separators
               
for nb_cl=1:(q-1)
   engine.separators{nb_cl,q} =  intersect(engine.clusters{nb_cl}, engine.clusters{q});
end
                  
for nb_cl=(q+1):C
   engine.separators{q,nb_cl} =  intersect(engine.clusters{q}, engine.clusters{nb_cl});
end   
               
%'------------------------------- Recuperation of beta -----------------------------'   

% the recuperation of beta is done in the cluster q (parent cluster of in_cl)
% this is true when we add links (since we do it in this cluster) 
% however if the parents are already linked this is useless since the clusters are stable and thus beta exists in the parent cluster
            
[clpot{q},modif_pot]=compute_new_potential(clpot{q},pot_parents,ns);
