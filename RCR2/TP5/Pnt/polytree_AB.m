N = 3; 
dag = zeros(N,N); 
A = 1; 
B = 2; 
C = 3; 
dag(A,[C B]) = 1;

discrete_nodes = 1:N; 

node_sizes(1) = 2;
node_sizes(2) = 1;
node_sizes(3) = 1;

pnet = mk_pnet(dag, node_sizes, discrete_nodes);



pnet.CPD{A} = tabular_CPD(pnet, A, [1 1]); %a1 a2
pnet.CPD{B} =tabular_CPD(pnet, B, [1 1]); % b1|a1 b1|a2 b2|a1 b2|a2 b3|a1 b3|a2 
pnet.CPD{C} =tabular_CPD(pnet, C, [1 1]); % b1|a1 b1|a2 b2|a1 b2|a2 b3|a1 b3|a2 

evidence = cell(1,N); 
evidence{A} = 1;

var_interest=B;

disp('---------------- anytime -------------');
engine = MG_inf_engine(pnet);
[Bel_Cdt_new, cap_max,nb_add] = global_propagation(engine, evidence, var_interest, 1, 1,1,'neighbors' );
%affichage pour A
Bel_Cdt_new
