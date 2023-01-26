fid1=fopen('C:\anahla\pnt\graphi.m','w');
fid2=fopen('C:\cygwin\home\programmation\algorithmes\ki.m','w');
fid3=fopen('C:\cygwin\home\programmation\algorithmes\nombreki.m','w');
total_nb_links=0;
Ce=0;
tot1=0;nbki=0;temoin=0;
totj=0;
nbclauses=0; nbr=0;
node_save=[];
%paramétrage du réseau
nb_nodes=14;
nb_parent_max=3;
%initialisation du réseau
dag = zeros(nb_nodes,nb_nodes);

for node=nb_nodes:-1:2
   
   N_parent=randperm(nb_parent_max+1); 	%pour fixer le nombre de parents
   N_p=N_parent(1)-1;   						%le nombre effectif de parents       
   L_poss_parents_final=[];               %fixer la liste des patents possibles
   L_poss_parents=randperm(nb_nodes);
   j=1;
   for l=1:length(L_poss_parents);
      if (L_poss_parents(l) < node) 
         L_poss_parents_final(j)=L_poss_parents(l);
         j=j+1;
      end                                                                          
   end   
   N_p=min(N_p, length(L_poss_parents_final));
   list_parents=[];
   for k=1:N_p      
      list_parents(k)=L_poss_parents_final(k);
   end
   for lp=1:length(list_parents)
    dag(list_parents(lp),node)=1;
   end
end

%pour eviter les noeuds isolés
for i=1:nb_nodes   
   ps=parents(dag,i);
   cs=children(dag,i);
   if isempty(ps) & isempty(cs)   
     if i==1
     N_children=randperm(nb_nodes); 	
     N_c=N_children(1);  
     if N_c ==1
         N_c=N_children(2);  
     end
     dag(i,N_c)=1;
     else  
     N_parent=randperm(i-1); 	
     N_p=N_parent(1);  
     dag(N_p,i)=1;
    end
    end
end

%pour éviter les sous-graphes isolés 
marked_nodes=nb_nodes;
selected_node=nb_nodes;
list_nodes=nb_nodes;
ps=parents(dag,nb_nodes);
for ll=1:length(ps)
    list_nodes(length(list_nodes)+1)=ps(ll);
end
while (length(marked_nodes)+1) <= length(list_nodes)
    selected_node=list_nodes(length(marked_nodes)+1);
    marked_nodes=[marked_nodes selected_node];
    ps=parents(dag,selected_node);
    cs=children(dag,selected_node);
    for ll=1:length(ps)
        if ~ismember(ps(ll),list_nodes)
           list_nodes(length(list_nodes)+1)=ps(ll);
        end
    end
    for ll=1:length(cs)
        if ~ismember(cs(ll),list_nodes)
           list_nodes(length(list_nodes)+1)=cs(ll);
        end
    end
end
if length(list_nodes)==nb_nodes  %il s'agit d'un graphe connecté
fprintf(fid1,'%d\t',nb_nodes);
fprintf(fid1,'%d\n',nb_parent_max);
for node1=1:nb_nodes
    for node2=1:nb_nodes
        fprintf(fid1,'%d',dag(node1,node2));
        fprintf(fid1,'  ');
    end
    fprintf (fid1,'\n');
end
nodes = 1:nb_nodes;

%afin de fixer le domaine des variables
for node=1:nb_nodes
   %if mod(node,2)==0
      node_sizes(node) = 2; % prise en charge des variables binaires
      %else
      %node_sizes(node) = 3;
      %end
end
nb_links=length(find(dag==1));
total_nb_links=total_nb_links + nb_links;
% determination de la variable pnet
pnet = mk_pnet(dag, node_sizes, nodes);
directed = 0;
  
%====Generation des distributions de probabilités====
ns=node_sizes(:)';
for d=1:nb_nodes
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
  l=length(ps);
  if l==0  % noeud sans parent
     distribution=[1];nbki=nbki+1;
     for v=1:(ns(d)-1)
        % génération d'un entier
        x=exp(-(str2num(int2str(rand(1)*10))));nbki=nbki+1;
        if x > 7  x= 20; end
        % génération de la distibution
        distribution = [distribution x]; 
      end   
        for i=1:2 
           fprintf(fid2,'%d \n',str2num(int2str(-log(distribution(i)))));
        end
        %generation des distributions avec un degré maximal égale à 1
  else 
     decalage=1;
     for m=1:l
        decalage=decalage*ns(ps(m)); %valeur de decalage
     end
         j=decalage*ns(d); % nombre de valeurs dans la distribution   
         for i= 1:j
            x=exp(-(str2num(int2str(rand(1)*10))));nbki=nbki+1;
            if x > 7  x= 20; end % génération de distributions = 0

         distribution(i) = x;
     end
    for i=1:decalage
        if mod(i,2)==0
           distribution(i) =1;
           nbr=nbr+1;
        else
           distribution(i+decalage)=1;
           nbr=nbr+1;
        end
    end
    for i=1:j
   fprintf(fid2,'%d \n',str2num(int2str(-log(distribution(i)))));
  end
end 
% integration des distributions dans la variable pnet
pnet.CPD{d} = tabular_CPD(pnet, d, distribution);
fprintf(fid1,' %f\n',distribution);
nbclauses=nbclauses+2^nbr;
end

% génération aléatoire d'une évidence 
evidence = cell(1,nb_nodes);
var=randperm(nb_nodes);
var_evidence1=var(1);            % relative à une evidence

instance1=randperm(ns(var_evidence1));     % pour choisir la première ou la deuxième valeur
instance_evidence1=instance1(1);
evidence{var_evidence1} = instance_evidence1;  
% génération aléatoire de la variable d'intérêt
var_interest=var(4);
instance3=randperm(ns(var_interest));
instance_interest=instance3(2);
fprintf (fid1,'%d\n',var_evidence1);
fprintf (fid1,'%d\n',instance_evidence1);
fprintf (fid1,'%d\n',var_interest);
fprintf (fid1,'%d\n',instance_interest);
if acyclic(pnet.dag,directed)==0
   % il s'agit d'un graphe multy connected
    engine = prod_jtree_inf_engine(pnet); temoin=1;
    else   
       % il s'agit d'un polytree
    engine=prod_pearl_inf_engine(pnet);temoin=0;
 end  
%prise en charge de l'évidence par l'engine%
tic; % démarrer la comptabilisation du temps de propagation
[engine] = global_propagation(engine, evidence); 
%prise en charge de la variable d'intérêt%
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest);
t2=toc; % arrêt de la comptabilisation du temps de propagation
fprintf(fid1,'%f \n',BEL_Cdt_classique);
fprintf(fid1,'%f \n',t2); fprintf(fid3,'%d \n',nbki);
if(temoin==0) fprintf(fid1,'polytree');
else fprintf(fid1,'multyconnected');
end
end
Ce
fclose('all');

