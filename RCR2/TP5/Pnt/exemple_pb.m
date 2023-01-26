N = 3;
dag = zeros(N,N);
A = 1; B = 2; C = 3; 
dag(A,[C B]) = 1;


nodes = 1:N;
node_sizes(1) = 2;
node_sizes(2) = 2;
node_sizes(3) = 2;

pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{A} = tabular_CPD(pnet, A, [1 1]); 
pnet.CPD{B} = tabular_CPD(pnet, B, [1 1 1 1]); 
pnet.CPD{C} = tabular_CPD(pnet, C, [1 1 1 1]); 

evidence = cell(1,N);
interest=cell(1,N);

evidence{A} = 1;
interest{B}=1;


disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);


tic; [Bel_Cdt_new, cap_max] = global_propagation(engine, evidence, interest, 1,1,'neighbors'); toc;

