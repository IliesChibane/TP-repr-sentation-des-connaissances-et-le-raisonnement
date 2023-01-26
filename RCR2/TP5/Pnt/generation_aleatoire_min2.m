


Ce=[];
Ce2=[];

nbequal=0;

for nb_exemple=1:200 % number of example
    
node_save=[];

disp('------------------One Example-----------------------------------')
sprintf('Example %d',nb_exemple)
 
levels=[3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];  % each value corresponds to a level; the first corresponds to roots number % 10 5 10

nb_nodes=sum(levels);

index_var=1;   

dag = zeros(nb_nodes,nb_nodes);

N_level_one=levels(1); 				% roots number                          	
N_level_two=levels(2);  	    	% number of the rest of variables   		
var_level_one=index_var:N_level_one;
index_var=index_var+N_level_one;
var_level_two=index_var:((index_var+N_level_two)-1);
        
for level=1:(length(levels)-1)

%==============================Random generation of the DAG structure============================
   if level > 1

        N_level_one=levels(level); 				% roots number                          	
        N_level_two=levels(level+1);  	    	% number of the rest of variables   		

        var_level_one=var_level_two;
        index_var=index_var+N_level_one;
        var_level_two=index_var:((index_var+N_level_two)-1);
   end

        N_child_max=2;  				% number max of children                  %ne doit pas etre superieur a un des level  	

        N = N_level_one+N_level_two;
   for i=var_level_one(1):var_level_one(N_level_one)    
       
   
   N_child=randperm(N_child_max); 	    	%to fix the children number
   N_c=N_child(1);   						%the effective number of children      
   %fix the list of possible children
   L_poss_child_final=[];
   L_poss_child=randperm(var_level_two(N_level_two));
   j=1;
   
   for l=1:length(L_poss_child);
      if (L_poss_child(l) >= var_level_two(1))
         L_poss_child_final(j)=L_poss_child(l);
         j=j+1;
      end
   end   
   
  
   list_child=[];
   
   if (i ~= 1) & (i ~=last_child)   %to avoid disconnected DAGs (i ~=last_child : to avoid that a node become its proper parent)
      dag(i,last_child)=1;
   end
   
   for k=1:N_c      
      list_child(k)=L_poss_child_final(k);
   end
   
   
   last_child=list_child(N_c);

   dag(i,list_child)=1;
   

end

for i=var_level_two(1):var_level_two(N_level_two)   
   ps=parents(dag,i);
   if isempty(ps)      
     N_parent=randperm(N_level_one);    
     N_p=N_parent(1);   
     dag(N_p,i)=1;
  end
end

%to form loops
set= N_level_one+div(N_level_two,2)+1;
decalage=div(N_level_two,2);

if decalage ~= 0
for i=set:N
   dag(i-decalage,i)=1;
end
end

end %level

%----------------------------------------------------------------------------------

%pour le calcul du nb de parents max
ps=parents(dag,1);
for i=2:N
    if length(parents(dag,i))> length(ps)
        ps=parents(dag,i);
    end
end

nb_parent_max=length(ps)

nodes = 1:nb_nodes;

%to fix the domain of variables
for node=1:nb_nodes
   if mod(node,2)==0
      node_sizes(node) = 2;
   else
      node_sizes(node) = 3;
   end
end

 

pnet = mk_pnet(dag, node_sizes, nodes);


%===========================Generation of the probability distribution======================

ns=node_sizes(:)';

for d=1:nb_nodes
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
  l=length(ps);
  
  if l==0  
     distribution=[1];
     for v=1:(ns(d)-1)
        x=rand(1);
        if x<0.15
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
        x=rand(1);
        if x<0.15
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

for_save.node=d;
for_save.ps=parents(dag,d);
for_save.distribution=distribution;

node_save=[node_save for_save];

pnet.CPD{d} = tabular_CPD(pnet, d, distribution);
 
end % grand for


%---------------------------------------------------------------------------------------
evidence = cell(1,nb_nodes);

var=randperm(nb_nodes);
var_evidence1=var(1);            % relative à une evidence
var_evidence2=var(2);            % relative à une evidence

instance=randperm(2);     % pour choisir la première ou la deuxième valeur
instance_evidence1=instance(1);
instance_evidence2=instance(2);

evidence{var_evidence1} = instance_evidence1;  
evidence{var_evidence2} = instance_evidence2;  

var_interest=var(4);

disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = enter_evidence(engine, evidence, var_interest); toc;

Bel_Cdt=Bel_Cdt_new

disp('----------------classique-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = enter_evidence(engine, evidence);toc;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T

equal=1;

if ~isequal(Bel_Cdt, BEL_Cdt_classique)

    equal=0;
    Ce=[Ce nb_exemple]
    save c:\anahla\nah2 nb_exemple levels nodes node_sizes dag node_save evidence var_interest
   
    engine = MG_inf_engine(pnet);
    tic; [Bel_Cdt_new] = enter_evidence2(engine, evidence, var_interest); toc;    %affichage pour A
    Bel_Cdt2=Bel_Cdt_new

    if ~isequal(Bel_Cdt2, BEL_Cdt_classique)
    Ce2=[Ce2 nb_exemple]
    end
   
end;


nbequal=nbequal + equal;

end
nb=nbequal



