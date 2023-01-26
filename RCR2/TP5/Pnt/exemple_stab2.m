N = 4;
dag = zeros(N,N);
A = 1; C = 2; B = 3; D = 4; 
%logique met B puis C mais j'ai fais comme ca pour etre conforme avec excel et le fait que je rendrais C parent de B
dag(A,[C B]) = 1;
dag(B,D) = 1;
dag(C,D)=1;

nodes = 1:N;
node_sizes = 2*ones(1,N);

node_sizes(4) = 3;


pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{A} = tabular_CPD(pnet, A, [1 0.9]); %[a -a]
pnet.CPD{B} = tabular_CPD(pnet, B, [0.3 1 1 0.2]); %[b|a b|-a -b|a -b|-a]
pnet.CPD{C} = tabular_CPD(pnet, C, [1 0 0.4 1]); %[c|a c|-a -c|a -c|-a]
pnet.CPD{D} = tabular_CPD(pnet, D, [0.44 1 0.42 1 1 0.8 0 1 0.64 0.34 0.98 0.6]); %[d|cb d|-cb d|c-b d|-c-b -d|cb -d|-cb -d|c-b -d|-c-b] 


evidence = cell(1,N);
var_interest=[1];

evidence{D} =[2];

disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = enter_evidence(engine, evidence, var_interest,0,500); toc;


