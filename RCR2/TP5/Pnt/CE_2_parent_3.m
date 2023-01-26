N = 6;

     nodes= [1 2 3 4 5 6];

node_sizes= [3 2 3 2 3 2];

dag=zeros(N,N);

dag=[
     0     0     1     1     1     0
     0     0     1     1     0     1
     0     0     0     0     0     0
     0     0     0     0     0     1
     0     0     0     0     0     0
     0     0     0     0     0     0]; 
  
  pnet = mk_pnet(dag, node_sizes, nodes);
  
names = {'1' ,    '2',     '3' ,    '4' ,    '5', '6'}; 
carre_rond = [1 1 1 1 1 1]; 
draw_layout(pnet.dag,names,carre_rond);


pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.9009    0.6108]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[1.0000    0.6772]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[0.4612    1.0000    0.5263    1.0000    0.3523    1.0000    1.0000         0    1.0000    0.8744    1.0000    0.2468    0.8851    0.3076  0.4514         0    0.8377    0.3801]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[0.3782    1.0000    0.2220    1.0000         0    1.0000    1.0000    0.5356    1.0000    0.7407    1.0000    0.9784]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0.3334    1.0000    0.8836    1.0000         0    1.0000    0.4479         0    0.3106]); 
pnet.CPD{6} = tabular_CPD(pnet, 6,[0.5353    1.0000    0.1901    1.0000    1.0000    0.7426    1.0000    0.2642]); 

evidence = cell(1,N);

evidence{4} = 1;  
evidence{6} = 1;  
var_interest= 3;
instance_interest=3;
evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  


disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 0, 2,'neighbors'); t1=toc;
Bel_Cdt=Bel_Cdt_new

disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t2=toc;
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

if ~isequal(Bel_Cdt, BEL_Cdt_classique)
    
   Ce=Ce+1;
   
   nah

end
