
%'ok plus de pb'

N = 5;


nodes= [1 2 3 4 5];

node_sizes= [3     2     3     2     3];

dag=zeros(N,N);

dag=[
      0     0     0     1     1;
     0     0     0     1     0;
     0     0     0     1     1;
     0     0     0     0     1;
     0     0     0     0     0;	];
 
 

pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.6031    0.6191]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[1.0000    0.2038]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[1.0000    0.4260    0.7427]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[0.5714    1.0000    0.3762    1.0000    0.4777    1.0000    0.4076    1.0000    0.7622    1.0000    0.7347    1.0000    0.3441    1.0000  0.8565    1.0000    0.3561    1.0000    1.0000         0    1.0000    0.2657    1.0000    0.7186    1.0000    0.2207    1.0000    0.4304 1.0000    0.8553    1.0000    0.7750    1.0000    0.6934    1.0000    0.8119]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0.9646    1.0000         0    1.0000    0.5671    1.0000    0.5270    1.0000         0    1.0000    0.9515    1.0000    0.3511    1.0000 0.9298    1.0000    0.2672    1.0000    1.0000    0.4898    1.0000    0.4544    1.0000    0.2565    1.0000    0.8906    1.0000    0.3936 1.0000    0.2309    1.0000    0.6286    1.0000    0.2516    1.0000    0.2104    0.5373         0    0.2311         0    0.3444    0.9914 0.2253         0    0.4021    0.7639    0.6906    0.6907    0.7234    0.6560    0.8696    0.5700    0.5049    0.9823]); 

evidence = cell(1,N);

evidence{2} = 2;  
evidence{5} = 2;  

var_interest= 1;

for d=1:N
  node_n=d
  ps = parents(dag,d)
end

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

