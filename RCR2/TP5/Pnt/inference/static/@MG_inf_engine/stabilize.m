function [clpot,alpha_stable, cap_max]=stabilize(pnet,engine,  clpot, C,ns, nb_nodes,nodes_type)

%The stabilization is performed via a message passing between different clusters. 
%We should define the neighbors number used instabilisation (neighbor)
%'----------------------------------------------------------------------------------------------------------------------------'

switch nb_nodes
    
case 1,  
[clpot]=one_node_stability(engine, pnet, clpot, C);
alpha_stable=maximum_value(clpot{1},C);
cap_max=0;

case 2, 
modif_pot=1;
while modif_pot==1
[clpot]=one_node_stability(engine, pnet, clpot, C);
[clpot,modif_pot, cap_max]=two_nodes_stability(pnet, engine, clpot, C,ns,nodes_type);
end

alpha_stable=maximum_value(clpot{1},C);

case 3, 
modif_pot=1;
while modif_pot==1
[clpot]=one_node_stability(engine, pnet, clpot, C);
[clpot,modif_pot, cap_max]=three_nodes_stability(pnet, engine, clpot, C,ns,nodes_type);
end
alpha_stable=maximum_value(clpot{1},C);

case 'n_best',   
modif_pot=1;
while modif_pot==1
[clpot]=one_node_stability(engine, pnet, clpot, C);
[clpot, modif_pot, cap_max]=n_best_nodes_stability(pnet, engine, clpot, C,ns,nodes_type);
end
alpha_stable=maximum_value(clpot{1},C);

case 'n',   
modif_pot=1;
while modif_pot==1
[clpot]=one_node_stability(engine, pnet, clpot, C);
[clpot, modif_pot, cap_max]=n_nodes_stability(pnet, engine, clpot, C,ns,nodes_type);
end
alpha_stable=maximum_value(clpot{1},C);

end