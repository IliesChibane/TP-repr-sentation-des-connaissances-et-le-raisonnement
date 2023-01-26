N = 5;

     nodes= [1 2 3 4 5];

node_sizes= [3 2 3 2 3];

dag=zeros(N,N);

dag=[
     0     1     1     0     0
     0     0     1     0     1
     0     0     0     0     0
     0     0     0     0     1
     0     0     0     0     0]; 
  

  pnet = mk_pnet(dag, node_sizes, nodes);
  
names = {'1' ,    '2',     '3' ,    '4' ,    '5'}; 
carre_rond = [1 1 1 1 1]; 
draw_layout(pnet.dag,names,carre_rond);


pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.2436    0.2419]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[0.9976    1.0000         0    1.0000    0.4626    1.0000]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[0.6676    1.0000    0.6193    1.0000    0.7112    1.0000    1.0000 0.6022    1.0000    0.6894    1.0000    0.8937    0.5022    0.2535    0.5914    0.9037    0.2098    0.9430]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[1.0000    0.1739]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0.5421    1.0000         0    1.0000    1.0000    0.5023    1.0000 0.2099    0.6788    0.5285    0.7247    0.8019]); 

evidence = cell(1,N);

evidence{1} = 2;  
evidence{5} = 2;  
var_interest= 4;
instance_interest=2;
evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  


disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 0, 1); t1=toc;
Bel_Cdt=Bel_Cdt_new

disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t2=toc;
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

if ~isequal(Bel_Cdt, BEL_Cdt_classique)
    
  
   nah

end
