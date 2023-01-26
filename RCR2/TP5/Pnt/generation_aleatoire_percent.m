
for ll=20:20            %pour fixer les levels
 
  
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
tab_levels{4}=[5    5  15 15																	]	;
tab_levels{3}=[10	15	15																		]	;
tab_levels{2}=[20 25																			]	;
tab_levels{2}=[20 25																			]	;


disp('------------------Level-----------------------------------')
sprintf('Level %d',ll)

Ce=[];
Ce2N=[];
Ce2PC=[];
Ce2C=[];
Ce2P=[];
Ce3N=[];
Ce3PC=[];
Ce3C=[];
Ce3P=[];
Ce_n_best_N=[];
Ce_n_best_PC=[];
Ce_n_best_C=[];
Ce_n_best_P=[];
Ce_n_N=[];
Ce_n_PC=[];
Ce_n_C=[];
Ce_n_P=[];

cap_max2N=0;
cap_max2PC=0;
cap_max2C=0;
cap_max2P=0;
cap_max3N=0;
cap_max3PC=0;
cap_max3C=0;
cap_max3P=0;
cap_max_n_best_N=0;
cap_max_n_best_PC=0;
cap_max_n_best_C=0;
cap_max_n_best_P=0;
cap_max_n_N=0;
cap_max_n_PC=0;
cap_max_n_C=0;
cap_max_n_P=0;

temps0=[];
temps1=[];  %save the time for one-neighbor
temps2N=[];  %save the time for two-neighbors
temps2P=[];  %save the time for two-parents
temps2C=[];  %save the time for two-children
temps2PC=[];  %save the time for two-parents-children
temps3N=[];  %save the time for three-neighbors
temps3P=[];  %save the time for three-parents
temps3C=[];  %save the time for three-children
temps3PC=[];  %save the time for three-parents-children
temps_n_best_N=[];  %save the time for n-neighbors
temps_n_best_P=[];  %save the time for n-parents
temps_n_best_C=[];  %save the time for n-children
temps_n_best_PC=[];  %save the time for n-parents-children
temps_n_N=[];  %save the time for n-neighbors
temps_n_P=[];  %save the time for n-parents
temps_n_C=[];  %save the time for n-children
temps_n_PC=[];  %save the time for n-parents-children


nbequal=0;

total_nb_links=0;

total_nb_example=200;

for nb_exemple=1:total_nb_example % number of example
    
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

        N_child_max=2;  				% number max of children                  %ne doit pas etre superieur a un des level   %j'ai un pb si je mets 4 avec level 20	

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



%----------------------------------------------------------------------------------

nodes = 1:nb_nodes;

%to fix the domain of variables
for node=1:nb_nodes
   if mod(node,2)==0
      node_sizes(node) = 2;
   else
      node_sizes(node) = 3;
   end
end

nb_links=length(find(dag==1));

total_nb_links=total_nb_links + nb_links;

pnet = mk_pnet(dag, node_sizes, nodes);


%===========================Generation of the possibility distribution======================

ns=node_sizes(:)';

for d=1:nb_nodes
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


instance1=randperm(ns(var_evidence1));     % pour choisir la première ou la deuxième valeur
instance2=randperm(ns(var_evidence2));
instance_evidence1=instance1(1);
instance_evidence2=instance2(2);

evidence{var_evidence1} = instance_evidence1;  
evidence{var_evidence2} = instance_evidence2;  

var_interest=var(4);
instance3=randperm(ns(var_interest));
instance_interest=instance3(2);

evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  


%-------------------------------------ALGORITHMS-------------------------------------
%---------------------------------------------------------------------------------------

disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max] = global_propagation(engine, evidence_new, [], [], 0, 1, 'neighbors'); t1=toc;
temps1{nb_exemple}=t1;
Bel_Cdt=Bel_Cdt_new

disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t0=toc;
temps0{nb_exemple}=t0;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

equal=1;

if ~isequal(Bel_Cdt, BEL_Cdt_classique)

    Ce=[Ce nb_exemple]
    
    equal=0;
    
    disp('----------------new 2 parents-------------');
    engine = MG_inf_engine(pnet);
    tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
    temps2P{nb_exemple}=t2;
    %affichage pour A
    Bel_Cdt2P=Bel_Cdt_new
    
    if cap_max==1
        cap_max2P=cap_max2P+1
    end
    
    if ~isequal(Bel_Cdt2P, BEL_Cdt_classique)
        
        Ce2P=[Ce2P nb_exemple]
        
        equal=0;
        
        disp('----------------new 2 children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps2C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt2C=Bel_Cdt_new
        
        if cap_max==1
        cap_max2C=cap_max2C+1
        end
        
       
        if ~isequal(Bel_Cdt2C, BEL_Cdt_classique)
        
        Ce2C=[Ce2C nb_exemple]
        
        disp('----------------new 2 parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps2PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt2PC=Bel_Cdt_new
        
        if cap_max==1
        cap_max2PC=cap_max2PC+1
        end
        
        if ~isequal(Bel_Cdt2PC, BEL_Cdt_classique)
        
        Ce2PC=[Ce2PC nb_exemple]
         
        disp('----------------new 2 neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps2N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt2N=Bel_Cdt_new
       
        if cap_max==1
        cap_max2N=cap_max2N+1
        end
        
        %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        if ~isequal(Bel_Cdt2N, BEL_Cdt_classique)
            
        Ce2N=[Ce2N nb_exemple]
        
        disp('----------------new 3 parents-------------');
    engine = MG_inf_engine(pnet);
    tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
    temps3P{nb_exemple}=t2;
    %affichage pour A
    Bel_Cdt3P=Bel_Cdt_new
    
    if cap_max==1
        cap_max3P=cap_max3P+1
    end
    
    if ~isequal(Bel_Cdt3P, BEL_Cdt_classique)
        
        Ce3P=[Ce3P nb_exemple]
        
        equal=0;
        
        disp('----------------new 3 children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt3C=Bel_Cdt_new
        
        if cap_max==1
        cap_max3C=cap_max3C+1
        end
        
       
        if ~isequal(Bel_Cdt3C, BEL_Cdt_classique)
        
        Ce3C=[Ce3C nb_exemple]
        
        disp('----------------new 3 parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt3PC=Bel_Cdt_new
        
        if cap_max==1
        cap_max3PC=cap_max3PC+1
        end
        
        if ~isequal(Bel_Cdt3PC, BEL_Cdt_classique)
        
        Ce3PC=[Ce3PC nb_exemple]
         
        disp('----------------new 3 neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt3N=Bel_Cdt_new
       
        if cap_max==1
        cap_max3N=cap_max3N+1
        end
        
        %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        if ~isequal(Bel_Cdt3N, BEL_Cdt_classique)
            
        Ce3N=[Ce3N nb_exemple]
        
        disp('----------------new n-best parents-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_P{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_P=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_best_P=cap_max_n_best_P+1
        end
        
        if ~isequal(Bel_Cdt_n_best_P, BEL_Cdt_classique)
            
        Ce_n_best_P=[Ce_n_best_P nb_exemple]
       
        disp('----------------new n-best children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_C=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_best_C=cap_max_n_best_C+1
        end
        
        if ~isequal(Bel_Cdt_n_best_C, BEL_Cdt_classique)
        
        Ce_n_best_C=[Ce_n_best_C nb_exemple]
        
        disp('----------------new n-best parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_PC=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_best_PC=cap_max_n_best_PC+1
        end
        
        if ~isequal(Bel_Cdt_n_best_PC, BEL_Cdt_classique)
        
        Ce_n_best_PC=[Ce_n_best_PC nb_exemple]
         
        disp('----------------new n-best neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_N=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_best_N=cap_max_n_best_N+1
        end
        
        %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        if ~isequal(Bel_Cdt_n_best_N, BEL_Cdt_classique)
            
        Ce_n_best_N=[Ce_n_best_N nb_exemple]        
        
        disp('----------------new n-best parents-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_P{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_P=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_P=cap_max_n_P+1
        end
        
        if ~isequal(Bel_Cdt_n_P, BEL_Cdt_classique)
            
        Ce_n_P=[Ce_n_P nb_exemple]
       
        disp('----------------new n children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_C=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_C=cap_max_n_C+1
        end
        
        if ~isequal(Bel_Cdt_n_C, BEL_Cdt_classique)
        
        Ce_n_C=[Ce_n_C nb_exemple]
        
        disp('----------------new n parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_PC=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_PC=cap_max_n_PC+1
        end
        
        if ~isequal(Bel_Cdt_n_PC, BEL_Cdt_classique)
        
        Ce_n_PC=[Ce_n_PC nb_exemple]
         
        disp('----------------new n neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_N=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_N=cap_max_n_N+1
        end
        
       
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end

nbequal=nbequal + equal;

end

nb=nbequal;

%----------------------------------------------------------------------------------
%pour le calcul de la moyenne des liens

average_links=total_nb_links/ total_nb_example;


switch ll
case 2, 
save c:\anahla\level_2 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 3, 
save c:\anahla\level_3 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 4, 
save c:\anahla\level_4 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 5, 
save c:\anahla\level_5 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 6, 
save c:\anahla\level_6 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 7, 
save c:\anahla\level_7 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 8, 
save c:\anahla\level_8 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 9, 
save c:\anahla\level_9 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 10, 
save c:\anahla\level_10 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 11, 
save c:\anahla\level_11 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 12, 
save c:\anahla\level_12 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 13, 
save c:\anahla\level_13 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 14, 
save c:\anahla\level_14 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 15, 
save c:\anahla\level_15 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 16, 
save c:\anahla\level_16 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 17, 
save c:\anahla\level_17 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 18, 
save c:\anahla\level_18 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
case 19, 
save c:\anahla\level_19 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
otherwise, 
save c:\anahla\level_20 nbequal Ce Ce2N Ce2PC Ce2C Ce2P Ce3N Ce3PC Ce3C Ce3P Ce_n_best_N Ce_n_best_PC Ce_n_best_P Ce_n_best_C Ce_n_N Ce_n_PC Ce_n_P Ce_n_C temps0 temps1 temps2N temps2PC temps2C temps2P temps3N temps3PC temps3C temps3P temps_n_best_N temps_n_best_PC temps_n_best_C temps_n_best_P temps_n_N temps_n_PC temps_n_C temps_n_P average_links cap_max2N cap_max2PC cap_max2C cap_max2P cap_max3N cap_max3PC cap_max3C cap_max3P cap_max_n_best_N cap_max_n_best_PC cap_max_n_best_P cap_max_n_best_C cap_max_n_N cap_max_n_PC cap_max_n_P cap_max_n_C
end

clear all

clc

end


