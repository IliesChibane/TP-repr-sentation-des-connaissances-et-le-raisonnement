fid1=fopen('C:\anahla\pnt\graphe.m','w');
%fid2=fopen('C:\cygwin\home\ki.m','w');
%fid3=fopen('C:\cygwin\home\nombreki.m','w');
total_nb_links=0;
Ce=0;
tot1=0;nbki=0;temoin=0;
totj=0;
nbclauses=0; nbr=0;
total_nb_example=1;
%fprintf(fid1,'nombre exemples %d\n',total_nb_example);

nb_example=1;

while nb_example <= total_nb_example % number of example
   
node_save=[];


disp('------------------One Example-----------------------------------')
sprintf('Example %d ',nb_example )
nb_nodes=100;
nb_parent_max=3;

dag = zeros(nb_nodes,nb_nodes);

for node=nb_nodes:-1:2
   
   N_parent=randperm(nb_parent_max+1); 	    	%to fix the parent number
   N_p=N_parent(1)-1;   						%the effective number of parents      
   %fix the list of possible parents
   L_poss_parents_final=[];
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

%'------------------------------------------------------'

%to avoid disconnected nodes
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

%'------------------------------------------------------'

%to avoid disconnected subgraphs

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
if length(list_nodes)==nb_nodes  %connected
%'The DAG is connected'
%'------------------------------------------------------'
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

%to fix the domain of variables
for node=1:nb_nodes
   %if mod(node,2)==0
      node_sizes(node) = 2;
      %else
      %node_sizes(node) = 3;
      %end
end
nb_links=length(find(dag==1));
total_nb_links=total_nb_links + nb_links;
%rapport=total_nb_links/ nb_nodes
pnet = mk_pnet(dag, node_sizes, nodes);
directed = 0;
%if ~acyclic(pnet.dag, directed) %multiply
% 'The DAG is multiply connected'
nb_example = nb_example +1;
   
%===========================Generation of the probability distribution==
ns=node_sizes(:)';
for d=1:nb_nodes
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
  l=length(ps);
  if l==0  % noeud sans parent
     distribution=[1];nbki=nbki+1;
     for v=1:(ns(d)-1)
        x=exp(-(str2num(int2str(rand(1)*10))));nbki=nbki+1;
        distribution = [distribution x]; 
     end   
        for i=1:2 
           %fprintf(fid2,'%d \n',str2num(int2str(-log(distribution(i)))));
        end
        %x=rand(1);
        %if x<0.15
           %x=0;
        %end
       
        %generation of a distribution with a max degree equal to 1
    
    else 
     decalage=1;
     for m=1:l
        decalage=decalage*ns(ps(m)); %val de decalage
     end
         j=decalage*ns(d); % nb of values in the distribution   
         for i= 1:j
         x=exp(-(str2num(int2str(rand(1)*10))));nbki=nbki+1;
       %x=rand(1);
        %if x<0.15
           %x=0; 
        %end
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
   %fprintf(fid2,'%d \n',str2num(int2str(-log(distribution(i)))));
end
    
 end %if
 
   for_save.node=d;
for_save.ps=parents(dag,d);
for_save.distribution=distribution;

node_save=[node_save for_save];

pnet.CPD{d} = tabular_CPD(pnet, d, distribution);
 
%fprintf(fid1,'%d\n',d);
fprintf(fid1,' %f\n',distribution);
nbclauses=nbclauses+2^nbr;

end


%---------------------------------------------------------------------------------------
evidence = cell(1,nb_nodes);

var=randperm(nb_nodes);
var_evidence1=var(1);            % relative à une evidence
var_evidence2=var(2);            % relative à une evidence

instance1=randperm(ns(var_evidence1));     % pour choisir la première ou la deuxième valeur
%instance2=randperm(ns(var_evidence2));
instance_evidence1=instance1(1);
%instance_evidence2=instance2(2);

evidence{var_evidence1} = instance_evidence1;  
% evidence{var_evidence2} = instance_evidence2;  

var_interest=var(4);
instance3=randperm(ns(var_interest));
instance_interest=instance3(2);
fprintf (fid1,'%d\n',var_evidence1);
fprintf (fid1,'%d\n',instance_evidence1);
%fprintf (fid1,'var_evidence2=%d\n',var_evidence2);
%fprintf (fid1,'instance_evidence2=%d\n',instance_evidence2);
fprintf (fid1,'%d\n',var_interest);
fprintf (fid1,'%d\n',instance_interest);
if acyclic(pnet.dag,directed)==0
   disp('----------------junction-------------');
    engine = prod_jtree_inf_engine(pnet); temoin=1;
    else   
    disp('---------pearl-------');
    engine=prod_pearl_inf_engine(pnet);temoin=0;
 end  
%prise en charge de l'évidence par l'engine%
tic; [engine] = global_propagation(engine, evidence); 
%prise en charge de la variable d'intérêt%
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest);t2=toc;
fprintf(fid1,'%f \n',BEL_Cdt_classique);
fprintf(fid1,'%f \n',t2); 
%fprintf(fid3,'%d \n',nbki);
if(temoin==0) fprintf(fid1,'polytree'); else fprintf(fid1,'multyconnected'); end
totj=totj+t2;
end
Ce
fclose('all');
end
