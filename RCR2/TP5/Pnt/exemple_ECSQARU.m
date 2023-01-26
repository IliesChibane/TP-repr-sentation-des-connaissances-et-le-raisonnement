N = 4;
dag = zeros(N,N);
A = 1; B = 2; C = 3; D = 4;
dag(A,[C B]) = 1;
dag(B,D) = 1;
dag(C,D)=1;


nodes = 1:N;
node_sizes(1) = 2;
node_sizes(2) = 2;
node_sizes(3) = 2;
node_sizes(4) = 2;

pnet = mk_pnet(dag, node_sizes, nodes);

pnet.CPD{A} = tabular_CPD(pnet, A, [1 0.9]); %[a -a]
pnet.CPD{B} = tabular_CPD(pnet, B, [1 0 0.4 1]); %[b|a b|-a -b|a -b|-a]
pnet.CPD{C} = tabular_CPD(pnet, C, [0.3 1 1 0.2]); %[c|a c|-a -c|a -c|-a]
pnet.CPD{D} = tabular_CPD(pnet, D, [1 1 1 1 1 0.8 0 1]); %[d|bc d|-bc d|b-c d|-b-c -d|bc -d|-bc -d|b-c -d|-b-c] 


evidence = cell(1,N);
interest=cell(1,N);

evidence{D} = 2;
interest{A}=1;
%interest{B}=1;


disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);


%names = {'A','B','C','D'}; 
%carre_rond = [1 1 1 1]; 
%draw_layout(pnet.dag,names,carre_rond);

tic; [Bel_Cdt_new, best_instances, cap_max] = global_propagation(engine, [], [], 0,1,'neighbors'); toc;

if ~isempty(find(~isemptycell(interest)))

Bel_Cdt_new

else
Bel_Cdt_new    
disp('No variable of interest specified');
end

disp('----------------classique jtree prod-------------');
engine = prod_jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;

%affichage pour A

if ~isempty(find(~isemptycell(interest)))

for i=1:length(interest)
    
if ~isempty(interest{i})
    
marg = marginal_nodes(engine, i);
BEL_Cdt_classique=marg.T(interest{i})

end

end

else
    disp('No variable of interest specified');
end


disp('----------------classique jtree min-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;

%affichage pour A
if ~isempty(find(~isemptycell(interest)))

for i=1:length(interest)
    
if ~isempty(interest{i})
    
marg = marginal_nodes(engine, i);
BEL_Cdt_classique=marg.T(interest{i})

end

end

else
    disp('No variable of interest specified');
end







