N = 20;
dag = zeros(N,N);

dag(1,[18 19]) = 1;

dag(2,18) = 1;
dag(3,18) = 1;
dag(4,18) = 1;
dag(5,18) = 1;
dag(6,18) = 1;
dag(7,18) = 1;
dag(8,18) = 1;
dag(9,18) = 1;

dag(10,19) = 1;
dag(11,19) = 1;
dag(12,19) = 1;
dag(13,19) = 1;
dag(14,19) = 1;
dag(15,19) = 1;
dag(16,19) = 1;
dag(17,19) = 1;

dag(18,20)=1;
dag(19,20)=1;

nodes = 1:N;

node_sizes(1) = 2;
node_sizes(2) = 2;
node_sizes(3) = 2;
node_sizes(4) = 3;
node_sizes(5) = 3;
node_sizes(6) = 3;
node_sizes(7) = 3;
node_sizes(8) = 3;
node_sizes(9) = 3;
node_sizes(10) = 3;

node_sizes(11) = 2;
node_sizes(12) = 2;
node_sizes(13) = 2;
node_sizes(14) = 2;
node_sizes(15) = 2;
node_sizes(16) = 2;
node_sizes(17) = 2;
node_sizes(18) = 3;
node_sizes(19) = 3;
node_sizes(20) = 3;

pnet = mk_pnet(dag, node_sizes, nodes);

%===========================Generation of the possibility distribution======================

ns=node_sizes(:)';

for d=1:N
  distribution=[];
  sauv=[];
  ps = parents(dag,d)
  l=length(ps);
  
  if l==0  
     distribution=[1];
     for v=1:(ns(d)-1)
        x=div((rand(1)*10000),100)/100;
        if x<0.03
           x=0;
        end
        distribution = [distribution x]; %generation of a distribution with a max degree equal to 1
     end

     
  else 
     
     decalage=1;
     for m=1:l
        decalage=decalage*ns(ps(m)); %val de decalage
     end
     
     j=decalage*ns(d); % nb of values in the distribution   
    
     for i= 1:j
        x=div((rand(1)*10000),100)/100;
        if x<0.03
           x=0; 
        end
        distribution(i) = x;
     end
     
     for i=1:decalage
        if mod(i,2)==0
           distribution(i) =1;
        else
           distribution(i+decalage)=1;
        end
        
     end
     
 end %if

pnet.CPD{d} = tabular_CPD(pnet, d, distribution);
 
end % grand for


evidence = cell(1,N);
var_interest=[1];

evidence{3} = 2;


disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);


tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest,2, 0,2); toc;

if ~isempty(var_interest) 

Bel_Cdt_new

else
Bel_Cdt_new    
disp('No variable of interest specified');
end

disp('----------------classique-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;

%affichage pour A
if ~isempty(var_interest) 

marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(2)

else
    disp('No variable of interest specified');
end
    






