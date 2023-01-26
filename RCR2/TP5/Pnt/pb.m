N = 5;

nodes= [1 2 3 4 5];

node_sizes= [3     2     3     2     3];

dag=zeros(N,N);

dag=[
     0     0     1     1     0;
     0     0     0     1     1;
     0     0     0     1     0;
     0     0     0     0     1;
     0     0     0     0     0		];
 
pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{1} = tabular_CPD(pnet, 1,[1.0000    0.6981    0.8862]); 
pnet.CPD{2} = tabular_CPD(pnet, 2,[1.0000    0.4928]); 
pnet.CPD{3} = tabular_CPD(pnet, 3,[0.2926    1.0000    0.8889    1.0000    0.7520    1.0000    0.8278    0.8357         0]); 
pnet.CPD{4} = tabular_CPD(pnet, 4,[0.7831    1.0000    0.6426    1.0000    0.2239    1.0000         0    1.0000    0.6012    1.0000    0.5757    1.0000         0    1.0000 0    1.0000    0.7541    1.0000    1.0000    0.6859    1.0000    0.3646    1.0000    0.5981    1.0000    0.2100    1.0000    0.6652 1.0000    0.3475    1.0000    0.9201    1.0000    0.2579    1.0000    0.2422]); 
pnet.CPD{5} = tabular_CPD(pnet, 5,[0.4306    1.0000    0.7739    1.0000    1.0000    0.2015    1.0000         0         0    0.6471    0.9326    0.4252]); 

evidence = cell(1,N);

evidence{2} = 2;  
evidence{4} = 1;  

var_interest= 1;

disp('----------------nouveau--1-----------');
engine = MG_inf_engine(pnet);

tic; [Bel_Cdt_new] = enter_evidence(engine, evidence, var_interest,1,1); toc;

Bel_Cdt_new



%disp('----------------nouveau---2----------');
%engine = MG_inf_engine(pnet);

%tic; [Bel_Cdt_new] = enter_evidence(engine, evidence, var_interest,0,2); toc;

%Bel_Cdt_new

%disp('----------------classique-------------');
%engine = jtree_inf_engine(pnet);
%tic; [engine] = enter_evidence(engine, evidence); toc;
%affichage pour A
%marg = marginal_nodes(engine, var_interest);
%BEL_Cdt_classique=marg.T
