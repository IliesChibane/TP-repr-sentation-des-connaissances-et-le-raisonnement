N = 6; 
dag = zeros(N,N); 
A = 1; 
B = 2; 
C = 3; 
D = 4; 
E = 5; 
F = 6; 
dag(A,B) = 1;
dag(B,D) = 1;
dag(C,D) = 1;
dag(C,E) = 1;
dag(D,F) = 1;

discrete_nodes = 1:N; 

node_sizes(1) = 2;
node_sizes(2) = 3;
node_sizes(3) = 2;
node_sizes(4) = 2;
node_sizes(5) = 3;
node_sizes(6) = 2;


pnet = mk_pnet(dag, node_sizes, discrete_nodes);



pnet.CPD{A} = tabular_CPD(pnet, A, [1 0.6]); %a1 a2
pnet.CPD{B} =tabular_CPD(pnet, B, [1 0.2 0.2 0.4 0.1 1]); % b1|a1 b1|a2 b2|a1 b2|a2 b3|a1 b3|a2 
pnet.CPD{C} =tabular_CPD(pnet, C, [0.35 1]); %c1 c2
pnet.CPD{D} = tabular_CPD(pnet, D, [1 0.7 0.2 1 1 0  1 1 1 0.4 1 1]); %d1|b1c1 d1|b2c1 d1|b3c1 d1|b1c2 d1|b2c2 d1|b3c2 d2|b1c1 d2|b2c1 d2|b3c1 d2|b1c2 d2|b2c2 d2|b3c2
pnet.CPD{E} =tabular_CPD(pnet, E, [0.85 1 1 0.2 0.05 1]); %e1|c1 e1|c2 e2|c1 e2|c2 e3|c1 e3|c2 
pnet.CPD{F} =tabular_CPD(pnet, F, [0.65 1 1 0]); %f1|d1 f1|d2 f2|d1 f2|d2

evidence = cell(1,N); 
evidence{F} = 2;

var_interest=A;

var_evidence=F;
instance_evidence=2;

disp('---------------- Pearl -------------');
engine = pearl_inf_engine(pnet);
tic; engine = global_propagation(engine, evidence); toc;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt=marg.T


