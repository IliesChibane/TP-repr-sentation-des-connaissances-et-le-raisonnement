fid1=fopen('c:\cygwin\home\programmes\posgraphe.m','r');
fid2=fopen('c:\cygwin\home\programmation\algorithmes\test.m','w');
dist=fscanf(fid1,'%f');
nb_nodes=(dist(1));
nb_parent_max=(dist(2));
dag=zeros(nb_nodes,nb_nodes);
i=3;
for n=1:nb_nodes
    for n2=1:nb_nodes
        dag(n,n2)=(dist(i));
        i=i+1;
    end
end
nodes = 1:nb_nodes;
%afin de fixer le domaine des variables
for node=1:nb_nodes
   node_sizes(node) = 2; % prise en charge des variables binaires
end
% determination de la variable pnet
pnet = mk_pnet(dag, node_sizes, nodes);
directed = 0;



%determination des distributions
i=(nb_nodes*nb_nodes)+3;
for d=1:nb_nodes
    %d
    distribution=[];
  l=length(parents(dag,d));

for n=1:2^(l+1)
     
    distribution=[distribution dist(i)];i=i+1;
    % distribution
 end
     

 pnet.CPD{d} = tabular_CPD(pnet, d, distribution);
 fprintf(fid2,'%f\n',distribution);

end
%prise en charge de l'évidence
evidence=cell(1,nb_nodes);
var_evidence1=dist(i);i=i+1;
instance_evidence1=dist(i);i=i+1;
evidence{var_evidence1}=instance_evidence1;
var_interest=dist(i);i=i+1;
instance_interest=dist(i);
%prise en charge de l'évidence par l'engine%
if acyclic(pnet.dag,directed)==0
   % il s'agit d'un graphe multy connected
  engine = prod_jtree_inf_engine(pnet); temoin=1;
    else   
       % il s'agit d'un polytree
    engine=prod_pearl_inf_engine(pnet);temoin=0;
end  
fclose('all');
fid1=fopen('C:\cygwin\home\programmes\posgraphe.m','a');

tic; % démarrer la comptabilisation du temps de propagation
[engine] = global_propagation(engine, evidence); 
%prise en charge de la variable d'intérêt%
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest);
t2=toc; % arrêt de la comptabilisation du temps de propagation
fprintf(fid1,'%f \n',BEL_Cdt_classique);
fprintf(fid1,'%f \n',t2); 
if(temoin==0) fprintf(fid1,'polytree\n');
else fprintf(fid1,'multyconnected\n');
end 
draw_layout(dag);
 

