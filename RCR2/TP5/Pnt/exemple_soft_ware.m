
for nn=1:1000
N = 4;
dag = zeros(N,N);
A = 1; B = 2; C = 3; D = 4;
dag(A,[B C D]) = 1;
dag(B,C) = 1;
dag(C,D)=1;




nodes = 1:N;
node_sizes = 2*ones(1,N);

pnet = mk_pnet(dag, node_sizes, nodes);



%===========================Generation of the probability distribution======================

ns=node_sizes(:)';

for d=1:N
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
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

end

%pnet.CPD{A} = tabular_CPD(pnet, A, [1 0.9]); %[a -a]
%pnet.CPD{B} = tabular_CPD(pnet, B, [1 0 0.4 1]); %[b|a b|-a -b|a -b|-a]
%pnet.CPD{C} = tabular_CPD(pnet, C, [0.3 1 1 0.2]); %[c|a c|-a -c|a -c|-a]
%pnet.CPD{D} = tabular_CPD(pnet, D, [1 1 1 1 1 0.8 0 1]); %[d|bc d|-bc d|b-c d|-b-c -d|bc -d|-bc -d|b-c -d|-b-c] 


evidence = cell(1,N);
var_interest=[];

evidence{A} = 2;


disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);


%names = {'A','B','C','D'}; 
%carre_rond = [1 1 1 1]; 
%draw_layout(pnet.dag,names,carre_rond);



tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest,2, 0,1); toc;

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
    
end





