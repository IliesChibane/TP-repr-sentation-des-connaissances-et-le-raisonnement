N = 5;

     nodes= [1 2 3 4 5];

node_sizes= [3 2 3 2 3];

dag=zeros(N,N);

dag=[
     0     0     0     1     1
     0     0     1     1     1
     0     0     0     1     1
     0     0     0     0     0
     0     0     0     0     0]; 
  
  pnet = mk_pnet(dag, node_sizes, nodes);
  
names = {'1' ,    '2',     '3' ,    '4' ,    '5'}; 
carre_rond = [1 1 1 1 1]; 
draw_layout(pnet.dag,names,carre_rond);


pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000         0    0.8370]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[1.0000    0.7254]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[0.7868    1.0000    1.0000         0    0.6616    0.6394]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[0.8019    1.0000    0.3889    1.0000    0.5298    1.0000    0.3688    1.0000    0.9201    1.0000    0.9833    1.0000    0.3551    1.0000         0    1.0000    0.1636    1.0000    1.0000         0    1.0000    0.2137    1.0000         0    1.0000    0.4478    1.0000    0.6880    1.0000    0.9968    1.0000    0.2084    1.0000    0.9885    1.0000    0.4456]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0    1.0000    0.1993    1.0000    0.4856    1.0000    0.8775    1.0000    0.8172    1.0000    0.7012    1.0000    0.9709    1.0000    0.2282    1.0000         0    1.0000    1.0000    0.8897    1.0000    0.1771    1.0000    0.9278    1.0000    0.5319    1.0000    0.9586    1.0000    0.9411    1.0000    0.1942    1.0000    0.5055    1.0000    0.8652    0.8029    0.9154    0.6779         0    0.8543    0.7162    0.8644         0    0.6068    0.7726    0.2315    0.9450    0.6888    0.7435    0.9387    0.9261    0.2370         0]); 

evidence = cell(1,N);

evidence{4} = 2;  
evidence{5} = 2;  
var_interest= 3;
instance_interest=3;
evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  


disp('----------------classique jtree min-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;

marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(3)


evidence{15}=3; %au lieu de interest

    
disp('----------------stab-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, best_instances, cap_max,nb_add] = global_propagation(engine,  [], evidence_new ,0, 1, 'neighbors'); t1=toc;
%temps_add{nb_example}=t1
Bel_Cdt_add=Bel_Cdt_new
cap_max
if cap_max==1
 cap_max_add=cap_max_add+1
end
   
disp('----------------consistency 2-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, best_instances, cap_max] = global_propagation(engine, [], evidence_new ,2, 1, 'neighbors'); t1=toc;
%temps_best{nb_example}=t1
Bel_Cdt_best=Bel_Cdt_new
if cap_max==1
 cap_max_best=cap_max_best+1
end
