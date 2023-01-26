N = 7;

nodes= [1 2 3 4 5 6 7 ];

node_sizes= [3 2 3 2 3 2 3 ];

dag=zeros(N,N);

dag=[0     0     1     1     1     0     0     
     0     0     1     1     1     0     0     
     0     0     0     0     1     0     1     
     0     0     0     0     0     0     0     
     0     0     0     0     0     1     0     
     0     0     0     0     0     0     1     
     0     0     0     0     0     0     0     
     ]; 
  
  pnet = mk_pnet(dag, node_sizes, nodes);
  
names = {'1' ,    '2',     '3' ,    '4' , '5', '6', '7'}; 
carre_rond = [1 1 1 1 1 1 1 ]; 
draw_layout(pnet.dag,names,carre_rond);


pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.9363    0.2240]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[ 1.0000    0.8552]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[0.5463    1.0000    0.5692    1.0000    0.1795    1.0000    1.0000    0.5088    1.0000         0    1.0000    0.2239    0.6707    0.5064 0.5590    0.7141    0.5655    0.4059]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[ 0.8215    1.0000    0.3328    1.0000    0.7363    1.0000    1.0000    0.9946    1.0000         0    1.0000    0.2788]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0.7563    1.0000    0.9959    1.0000    0.5346    1.0000    0.8161    1.0000    0.8246    1.0000    0.7398    1.0000    0.7544    1.0000 0.3467    1.0000    0.6012    1.0000    1.0000    0.7605    1.0000    0.4855    1.0000    0.9249    1.0000    0.6098    1.0000         0  1.0000    0.5185    1.0000    0.6776    1.0000    0.3983    1.0000         0    0.4750    0.2092    0.2387    0.3390    0.1979    0.4534  0    0.1911    0.2965         0    0.4158    0.2562    0.6902         0    0.4550    0.7246    0.4443    0.4154]); 
pnet.CPD{6} = tabular_CPD(pnet, 6,[ 0.7646    1.0000    0.5797    1.0000    0.6381    1.0000]); 
pnet.CPD{7} = tabular_CPD(pnet, 7,[0.2742    1.0000    0.2126    1.0000         0    1.0000    1.0000    0.5067    1.0000    0.2104    1.0000    0.4538    0.4066    0.2142 0.6568    0.3430    0.8111    0.6424]); 

evidence = cell(1,N);

evidence{2} = 1;  
evidence{7} = 2;  
var_interest= 4;
instance_interest=1;
evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  



%-------------------------------------ALGORITHMS-------------------------------------
%---------------------------------------------------------------------------------------

disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max] = global_propagation(engine, evidence, var_interest,instance_interest, 0,'n_best','neighbors'); toc;
Bel_Cdt=Bel_Cdt_new

disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t0=toc;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

