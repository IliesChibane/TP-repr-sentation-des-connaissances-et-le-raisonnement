 


engine = MG_inf_engine(pnet);

[Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, ck_cst,nb_nodes,nodes_type );

x=[' ' mat{var_interest}.name];

y=[' ' num2str(Bel_Cdt_new)];

msgbox(strcat('The possibility degree of ', x, '_',  num2str(instance_interest), ' is ', y), 'Result');





