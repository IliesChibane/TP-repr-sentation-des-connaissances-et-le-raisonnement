N = 5;

nodes= [1 2 3 4 5];

node_sizes= [3     2     3     2     3];

dag=zeros(N,N);

dag=[
     0     0     0     0     1;
     0     0     0     1     1;
     0     0     0     1     1;
     0     0     0     0     1;
     0     0     0     0     0		];
 
pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.8189    0.7494]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[1.0000    0.5896]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[1.0000    0.5891    0.3602]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[0    1.0000    0.1617    1.0000    0.3521    1.0000    1.0000    0.3470    1.0000    0.7631    1.0000         0]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0.5755    1.0000    0.9130    1.0000         0    1.0000    0.2723    1.0000    0.9856    1.0000    0.3009    1.0000    0.9031    1.0000 0.4922    1.0000         0    1.0000    0.1520    1.0000    0.6930    1.0000         0    1.0000    0.9447    1.0000    0.2849    1.0000 0.5636    1.0000    0.5576    1.0000    0.3123    1.0000    0.7046    1.0000    1.0000    0.1715    1.0000         0    1.0000    0.2299 1.0000    0.7638    1.0000    0.4552    1.0000    0.9926    1.0000         0    1.0000         0    1.0000    0.9598    1.0000    0.6609 1.0000    0.6868    1.0000    0.4088    1.0000    0.8322    1.0000    0.3347    1.0000    0.5251    1.0000    0.7166    1.0000    0.6572 1.0000    0.4758    0.6749         0    0.6955    0.3183    0.8295    0.7905    0.8002    0.9895    0.8698    0.8201    0.9506    0.5689 0    0.6458    0.2407         0    0.9876    0.7440    0.5461    0.4219    0.7862    0.8098    0.6288    0.3186    0.3027         0 0.6021    0.2244    0.8587    0.7536    0.2630    0.6691    0.8619    0.8412  0    0.8048]); 

evidence = cell(1,N);

evidence{3} = 1;  
evidence{4} = 2;  

var_interest= 5;

disp('----------------nouveau--n-----------');
engine = MG_inf_engine(pnet);


tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest,2, 2,1); toc;

Bel_Cdt_new


disp('----------------classique-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(2)
