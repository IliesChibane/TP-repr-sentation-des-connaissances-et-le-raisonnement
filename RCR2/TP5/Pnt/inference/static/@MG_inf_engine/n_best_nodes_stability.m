function [clpot, modif_pot, cap_max]=n_best_nodes_stability(pnet, engine,  clpot, C, ns,nodes_type)

%ds le rapport best\_multiple\_nodes\_stability

%This procedure ensures for each cluster its stability with respect to the best instances
%of its nodes using the procedure newpot_n_nodes_min}.

%--------------------------------------------------------------------------------------------------------------------

modif_pot=0;
cap_max=0;
i=1;


while (i<=C) & (modif_pot==0) & (cap_max==0)
    nodes=define_nodes(pnet.dag, engine, i, nodes_type, C);
    if length(nodes)>1
        [clpot{i}, modif_pot, cap_max]=newpot_n_best_nodes(clpot{i}, clpot, nodes, ns);
    end
    i=i+1;
end 