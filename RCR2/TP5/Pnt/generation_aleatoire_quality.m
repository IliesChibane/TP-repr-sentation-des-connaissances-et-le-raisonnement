

for ll=10:10
 
  
tab_levels{20}=[3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	]	;
tab_levels{19}=[3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3		]	;
tab_levels{18}=[3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3			]	;
tab_levels{17}=[3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3				]	;
tab_levels{16}=[3	3	3	3	3	3	3	3	3	3	3	3	3	3	3	3					]	;
tab_levels{15}=[3	3	3	3	3	3	3	3	3	3	3	4	4	4	4						]	;
tab_levels{14}=[3	3	3	3	3	3	4	4	4	4	4	4	4	4							]	;
tab_levels{13}=[3	3	3	4	4	4	4	4	4	4	4	4	4								]	;
tab_levels{12}=[3	3	3	3	3	3	3	3	4	4	4	4									]	;
tab_levels{11}=[3	3	3	3	4	4	4	4	4	4	4										]	;
tab_levels{10}=[4	4	4	4	4	4	4	4	4	4											]	;
tab_levels{9}=[5	5	5	5	3	3	3	3	8												]	;
tab_levels{8}=[5	5	5	5	5	5	5	5													]	;
tab_levels{7}=[5	5	5	5	5	5	10														]	;
tab_levels{6}=[5	5	5	5	10	10															]	;
tab_levels{5}=[5	5	10	10	10																]	;
tab_levels{4}=[5 10 15 15																	]	;
tab_levels{3}=[20	20	20																		]	;
tab_levels{2}=[20	40																			]	;

disp('------------------Level-----------------------------------')
sprintf('Level %d',ll)

Ce=[];
Ce2=[];
Ce3=[];


marginal_new_one_neighbor=[];
marginal_new_two_neighbors=[];
marginal_new_three_neighbors=[];
marginal_junction =[];
marginal_new_n_best_neighbors =[];

nbequal=0;

for nb_exemple=1:1 % number of example

whole_distribution=[];    
node_save=[];

disp('------------------One Example-----------------------------------')
sprintf('Example %d ',nb_exemple )
sprintf('Level %d',ll)

 
levels=tab_levels{ll};  % each value corresponds to a level; the first corresponds to roots number 

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

%===========================Generation of the possibility distribution======================

ns=node_sizes(:)';

for d=1:nb_nodes
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
  l=length(ps);
  
  if l==0  
     for v=1:(ns(d))
        x=div((rand(1)*10000),100)/100;
        if x<0.15
           x=0;
        end
        distribution = [distribution x]; %generation of a distribution with a max degree equal to 1
     end
     
     y=randperm(ns(d));
     y=y(1);
     distribution(y)=1; %for normalization
     
  else 
     
     decalage=1;
     for m=1:l
        decalage=decalage*ns(ps(m)); %val de decalage
     end
     
     j=decalage*ns(d); % nb of values in the distribution   
    
     for i= 1:j
        x=div((rand(1)*10000),100)/100;
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

whole_distribution=union(whole_distribution, distribution);
 
end % grand for

%---------------------------------------------------------------------------------------
evidence = cell(1,nb_nodes);

var=randperm(nb_nodes);
var_evidence1=var(1);            % relative à une evidence
var_evidence2=var(2);            % relative à une evidence

instance1=randperm(ns(var_evidence1));     % pour choisir la première ou la deuxième valeur
instance2=randperm(ns(var_evidence2));
instance_evidence1=instance1(1);
instance_evidence2=instance2(2);

evidence{var_evidence1} = instance_evidence1;  
evidence{var_evidence2} = instance_evidence2;  

var_interest=var(4);
instance3=randperm(ns(var_interest));
instance_interest=instance3(2);

disp('----------------new n-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 2, 1); toc;

Bel_Cdt=Bel_Cdt_new

nah

disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 0, 1); toc;

Bel_Cdt=Bel_Cdt_new

disp('----------------new 2-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 0, 500); toc;


disp('----------------new n-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 0, 500); toc;

Bel_Cdt=Bel_Cdt_new

disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); toc;

%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

%save results
    marginal_new_one_neighbor=[marginal_new_one_neighbor Bel_Cdt]
    marginal_new_two_neighbors=[marginal_new_two_neighbors Bel_Cdt]
    marginal_new_three_neighbors=[marginal_new_three_neighbors Bel_Cdt]
    marginal_new_n_best_neighbors=[marginal_new_n_best_neighbors Bel_Cdt]
    marginal_junction=[marginal_junction BEL_Cdt_classique]

equal=1;

if ~isequal(Bel_Cdt, BEL_Cdt_classique)

    Ce=[Ce nb_exemple]
    
    Ce_whole_distribution{length(Ce)}=whole_distribution;

    equal=0;
    
    
    %disp('----------------new 2-------------');
    %engine = MG_inf_engine(pnet);
    %tic; [Bel_Cdt_new] = global_propagation(engine, evidence, var_interest, instance_interest, 0, 2); toc;  
    %Bel_Cdt2=Bel_Cdt_new

    %affichage pour A
    %if ~isequal(Bel_Cdt2, BEL_Cdt_classique)
     %  Ce2=[Ce2 nb_exemple]
     %  marginal_new_two_neighbors=[marginal_new_two_neighbors Bel_Cdt2]
     %end
    
end

nbequal=nbequal + equal;

end

nb=nbequal;


switch ll
case 2, 
save c:\anahla\level_quality_2 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 3, 
save c:\anahla\level_quality_3 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 4, 
save c:\anahla\level_quality_4 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 5, 
save c:\anahla\level_quality_5 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 6, 
save c:\anahla\level_quality_6 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 7, 
save c:\anahla\level_quality_7 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 8, 
save c:\anahla\level_quality_8 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 9, 
save c:\anahla\level_quality_9 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 10, 
save c:\anahla\level_quality_10 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 11, 
save c:\anahla\level_quality_11 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 12, 
save c:\anahla\level_quality_12 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 13, 
save c:\anahla\level_quality_13 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 14, 
save c:\anahla\level_quality_14 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 15, 
save c:\anahla\level_quality_15 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 16, 
save c:\anahla\level_quality_16 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 17, 
save c:\anahla\level_quality_17 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 18, 
save c:\anahla\level_quality_18 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 
case 19, 
save c:\anahla\level_quality_19 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_n_best_neighbors Ce Ce2 Ce3 Ce_whole_distribution
otherwise, 
save c:\anahla\level_quality_20_1 nbequal marginal_junction marginal_new_one_neighbor marginal_new_two_neighbors marginal_new_three_neighbors marginal_new_n_best_neighbors Ce Ce2 Ce3 
end

clear all

clc

end


