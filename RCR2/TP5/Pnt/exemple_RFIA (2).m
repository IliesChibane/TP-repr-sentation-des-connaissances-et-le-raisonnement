N = 6;
dag = zeros(N,N);
A = 1; C = 2; B = 3; D = 4; F=5; E=6;
%logique met B puis C mais j'ai fais comme ca pour etre conforme avec excel et le fait que je rendrais C parent de B
dag(A,[C B]) = 1;
dag(B,D) = 1;
dag(C,D)=1;
dag(D,E)=1;
dag(F,E)=1;



nodes = 1:N;
node_sizes = 2*ones(1,N);

pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{A} = tabular_CPD(pnet, A, [1 0.9]); 
pnet.CPD{B} = tabular_CPD(pnet, B, [0.3 1 1 0.2]); 
pnet.CPD{C} = tabular_CPD(pnet, C, [1 0 0.4 1]); 
pnet.CPD{D} = tabular_CPD(pnet, D, [1 1 1 1 1 0.8 0 1]); 
pnet.CPD{F} = tabular_CPD(pnet, F, [1 0.2]); %[a -a]
pnet.CPD{E} = tabular_CPD(pnet, E, [1 1 1 0.2 0 0.8 0 1]); 


evidence = cell(1,N);
var_interest=A;
evidence{D} = 2;

disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = enter_evidence(engine, evidence, var_interest); toc;

Bel_Cdt_new

disp('----------------classique-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = enter_evidence(engine, evidence); toc;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T






