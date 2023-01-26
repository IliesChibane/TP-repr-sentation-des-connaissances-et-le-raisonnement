N = 4;

nodes= [1 2 3 4];

node_sizes= [3 2 3 2];

dag=zeros(N,N);

dag=[0     0     1     1
     0     0     1     1
     0     0     0     1
     0     0     0     0
     ]; 
  
pnet = mk_pnet(dag, node_sizes, nodes);
  


pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.1700    0.5000]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[ 1.0000    0.8700]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[0.8300    1.0000    0.8900    1.0000    0.1800    1.0000    1.0000    0.6000    1.0000    0.4300    1.0000    0.2700    0.7700    0.5800 0.6100    0.3200    0.4500    0.6900]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[0.7300    1.0000    0.6300    1.0000    0.1800    1.0000    0.7800    1.0000    0.9400    1.0000    0.1100    1.0000    0.3700    1.0000  0.4300    1.0000    0.3500    1.0000    1.0000    0.2100    1.0000    0.8700    1.0000    0.1000    1.0000    0.0600    1.0000    0.7000 1.0000    0.2500    1.0000    0.1100    1.0000    0.2300    1.0000    0.1100]); 

evidence = cell(1,N);

evidence{1} = 2;  
evidence{2} =1;  
var_interest= 3;
instance_interest=2;
evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  




disp('----------------classique jtree min-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;

marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)
    
disp('----------------stab-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, best_instances, cap_max,nb_add] = global_propagation(engine, [], evidence_new  ,0, 1, 'neighbors'); t1=toc;
Bel_Cdt_add=Bel_Cdt_new
cap_max
if cap_max==1
 cap_max_add=cap_max_add+1
end
   
disp('----------------consistency 2-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, best_instances, cap_max] = global_propagation(engine, [],  evidence_new, 2, 1, 'neighbors'); t1=toc;
Bel_Cdt_best=Bel_Cdt_new
if cap_max==1
 cap_max_best=cap_max_best+1
end


disp('----------------consistency 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, best_instances, cap_max,nb_add] = global_propagation(engine, [], evidence_new  , 1, 1, 'neighbors'); t1=toc;
Bel_Cdt_add=Bel_Cdt_new
cap_max
if cap_max==1
 cap_max_add=cap_max_add+1
end