
function [exist_global_instance,scale, sauv_index_clusters,cap_max]=compute_best_global_instances(cl,val_max,clpot,C);
%cl est inutile mais je n'ai pas pu l'enlever


%PRINCIPLE (same principle than newpot_n_best_nodes)

%This procedure affects to each cluster its max instances for it and for its nodes (parents, children etc.).
%For instance if the cluster AC has three nodes A, AB et CBD s.t. (the order of variables is important here we have A C B D) :
%- the potential of  AC is : ac=0.9 -ac=0 a-c=0.4 -a-c=0.9
%- the potential of  A is: a=0.9 -a=0.9
%- the potential of  AB is: ab=0.3 -ab=0.9 a-b=0.9 -a-b=0.2
%- the potential of  CBD is:cbd=0 -cbd=0 c-bd=0 -c-bd=0 cb-d=0.9 -cb-d=0.8 c-b-d=0 -c-b-d=0.9

%the program gives:
%- ac et -a-c : comme instances max dans AC
%- a-c-b-d et -acb-d: as max instances in  ACBD (union des domaines de tous les clusters)
%- ac et -ac as max instances in the union of the separators(AC) from AC
%- a-c et -ac as max instances in  the union of the separators (AC) from ABCD

%To construct the best elements in the cartesian product we follow this way:
%- for each cluster i we save its best instances in sauv_max_index{i} thus:
%* for  1 (i.e.  A): sauv_max_index{1}{1}= 1, sauv_max_index{1}{2}= 2
%* for  2 (i.e.  AB):sauv_max_index{2}{1}= 2 1, sauv_max_index{2}{2}= 1 2
%* for  3 (i.e.  CBD): sauv_max_index{3}{1}= 1 1 2, sauv_max_index{3}{2}= 2 2 2

%- we start with the cluster having the max number of values equal to max  (heuristic) and we save its best elements in
% a matrix called best_nodes_instances wich have as colums number the number of nodes in big_domain

%- In this example the first cluster to be treated is  A thus :
%* best_nodes_instances{1}= 1 0 0 0   % i.e.  the first instance of A and the others are not yet instanciated
%* best_nodes_instances{2}= 2 0 0 0 %i.e.  the second instance of A and the others are not yet instanciated

%- we save best_nodes_instances in sauv_best_nodes_instances and we reinitialize it at zero
%- we treat the rest of nodes by testing before their consistency with existing instances in best_nodes_instances

%-In this example :
%* the second cluster to be treated is AB and then we test if the instances of A already existing in best_nodes_instances are consistent with those of AB
%* we test  sauv_best_nodes_instances{1}= 1 0 0 0 with  sauv_max_index{2}{1}= 2 1 : pas de coherence
%* we test  sauv_best_nodes_instances{1}= 1 0 0 0 with  sauv_max_index{2}{2}= 1 2 :  consistency thus  best_nodes_instances{1}= 1 0 2 0
%* we test  sauv_best_nodes_instances{2}= 2 0 0 0 with  sauv_max_index{2}{1}= 2 1 : consistency thus  best_nodes_instances{2}= 2 0 1 0
%* we test  sauv_best_nodes_instances{2}= 2 0 0 0 with  sauv_max_index{2}{2}= 1 2 :  inconsistency 

%- the third cluster to be treated is CBD and then we test if the instances of B already existing in best_nodes_instances are consistent with those of CBD
%* we test  sauv_best_nodes_instances{1}= 1 0 2 0 with  sauv_max_index{3}{1}= 1 1 2 : inconsistency 
%* we test  sauv_best_nodes_instances{1}=  1 0 2 0 with  sauv_max_index{3}{2}= 2 2 2 :  consistency thus  best_nodes_instances{1}= 1 2 2 2
%* we test  sauv_best_nodes_instances{2}= 2 0 1 0 with  sauv_max_index{3}{1}= 1 1 2 : consistency thus  best_nodes_instances{2}= 2 1 1 2
%* we test  sauv_best_nodes_instances{2}= 2 0 1 0 with  sauv_max_index{3}{1}= 1 1 2  : inconsistency 

%- at the end we have two max instances: best_nodes_instances{1}= 1 2 2 2, best_nodes_instances{2}= 2 1 1 2 which correspond to: a-c-b-d et -acb-d

val_max

%'--------------------------------------------------------------------------------------'

scale=[];
           
%'--------------------------------------------------------------------------------------'

exist_global_instance=1;

treated_var=[];    %to mark treated variables

best_global_instances=[];

sauv_max_index=[];

index_clusters=[];

sauv_index_clusters=[];

%'---------------------compute the max instances for each cluster in clpot----------------------'

for i=1:C

index_clusters=find(clpot{i}.T==val_max);    %index of values equal to max in clpot(i)

big_matrix_clusters=def_mat(clpot{i}.sizes); %big matrix relative to clpot(i)

positions_clusters=[];

for j=1:length(index_clusters)
    positions_clusters{j}= big_matrix_clusters(index_clusters(j),:);
end

sauv_max_index{i}=positions_clusters;       %instances having a potential equal to max in clpot(i) are saved in sauv_max_index{i}

sauv_size(i)=length(index_clusters);        %sauv_size contains the number of values equal to max in each cluster     

sauv_index_clusters{i}=index_clusters;

end

[val,pos]=sort(sauv_size);                  %ordre croissant : to use in the heuristic

%for i=1:C
 %   sauv_index_clusters{i}
 %end
 
cap_max=0;
 
%if prod(val) > 200000000  %nb of tests at most but the pb is that it can be less 
 %   cap_max=1;
 %end
    
%'---------------------------------------------------Test cap_max----------------------------------------------------'

%for instanes if the first cluster has 5 max instances the second 3 and the thirst 7
%then pos=3 1 2 and the number of tests at at most 5*7+ 3*7= 7(5+3)

%'---------------------------------------------------if cap_max is not reached----------------------------------------------------'

if cap_max==0

%'---------------------computation of big_domain of all clusters----------------------'

big_domain=[];

for i=1:C
   
   big_domain=  myunion(big_domain, clpot{i}.domain);
   
end

%'--------------------treatement of the cluster having the less number of values equal to max  (heuristic)---------------------------------'

pos_treated_cluster=1;

treated_cluster=pos(pos_treated_cluster); %

for i=1:length(sauv_max_index{treated_cluster})
    best_global_instances{i}=zeros(1,length(big_domain));
end

dom=clpot{treated_cluster}.domain;
equiv_pos_dom=find_equiv_posns(dom, big_domain);

for i=1:length(sauv_max_index{treated_cluster})

    best_global_instances{i}([equiv_pos_dom])=[sauv_max_index{treated_cluster}{i}];

end    

treated_var=myunion(treated_var, dom);

%'-------------------------Updating scale-----------------'

for v=1:prod(clpot{treated_cluster}.sizes)
       if ~ismember(clpot{treated_cluster}.T(v), scale)
       scale=[scale,clpot{treated_cluster}.T(v)];
       end
end

%'-----------------treatement of the rest of clusters-----------------'

if C>2  %1 % there are more than one cluster

next=1;

pos_treated_cluster=2;

while (pos_treated_cluster <= C) & (next==1) %2
    
next_cluster=pos(pos_treated_cluster);

treated_coherent=0;    
    
dom=clpot{next_cluster}.domain;

equiv_pos_dom=find_equiv_posns(dom, big_domain);

%'----------------------Test the existance of treated variables-------------------------'

if sum(ismember(dom,treated_var))==0  %variables in dom does not exists in treated var
    treated=0;
else
    treated=1;
end

%'--------------------------------------------------------'

treated_var=myunion(treated_var, dom);

%'-------------------------Updating scale-----------------'

for v=1:prod(clpot{next_cluster}.sizes)
       if ~ismember(clpot{next_cluster}.T(v), scale)
       scale=[scale,clpot{next_cluster}.T(v)];
       end
end
 
%'--------------------------------------------------------'

sauv_best_global_instances=best_global_instances;

nb_best_global_instances=length(best_global_instances);

best_global_instances=[];

%'--------------------------------------------------------'

val_max_clusters=sauv_max_index{next_cluster};  %contient les valeur max dans next_cluster
   
length_val_max_cluster=length(val_max_clusters); %nb val max dans next_cluster

position_big_instance=1;

'ici1'

for i= 1:length_val_max_cluster %3  %parcours des instances max du treated cluster
    
    one_cluster_instance=sauv_max_index{next_cluster}{i};
    
    'ici2'
    
    nb_best_global_instances
    
    treated

    for j= 1:nb_best_global_instances %& find_instance==0   %4
        
        % '-------------------------yes treated------------------------'
       if treated ==1 %5 
                     
        one_big_instance=sauv_best_global_instances{j};  %prendre une instance max de big
        verif_index=[];
        verif_index=one_big_instance([equiv_pos_dom]);
        test_coherence=1;    %pour tester la coherence entre les var deja traitée
        k=1;
        
        'ici3'
        nb_best_global_instances
        j
        
        while (k<= length(verif_index)) & (test_coherence==1) 
            k
           if verif_index(k)~=0 
               val_1=verif_index(k); %la k eme valeur  a partir de big
               val_2=one_cluster_instance(k); %la k eme valeur dans l'instance max numero j relative a next_cluster 
               test_coherence=(val_1==val_2);        
           end 
           k=k+1;
        end         
        
        end  %5
        
%        '-------------------------The instances are consistent------------------'
               
        %if we exit with test_coherence==1 then we are sure that the treated instance is consistent

        if treated==0 | test_coherence==1  %6
        
        % '-------------------------The instances are consistent------------------'
            
        best_global_instances{position_big_instance}=sauv_best_global_instances{j};
       
        best_global_instances{position_big_instance}([equiv_pos_dom])=[one_cluster_instance];
        
        position_big_instance=position_big_instance+1;
        
        treated_coherent=1;
        
        end %6
        
    end %while j<= nb_best_global_instances & find_instance==0  %4
   
end % for i= 1:length_val_max_cluster %3

if treated_coherent==0 % there are no consistent instances in the treated cluster
            next=0;
            exist_global_instance=0;
            scale=sort(scale); %car on l'utiliser
end


pos_treated_cluster=pos_treated_cluster+1

%pos_treated_cluster=pos_treated_cluster-1; %changement de cluster

%if  pos_treated_cluster >= 1
	%next_cluster=pos(pos_treated_cluster)
    %end

end %2  %parcour des clusters

end %1  if C > 2

end %cap_max

%'----------------------------'


%for ii=1:length(best_global_instances)
 %   big=best_global_instances{ii}
 %end









