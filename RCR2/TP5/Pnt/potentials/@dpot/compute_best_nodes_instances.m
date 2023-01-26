function [exist_best_nodes_instances, best_nodes_instances, cap_max] =compute_best_nodes_instances(sauv_max_index, big_domain,potcl,clpot, nodes,pos)


%----------------------------------------------------------------------------------------------------------------------------------

%To construct the best elements in the cartesian product we follow this way 
%(we continue the example given in extract best instances):

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

%----------------------------------------------------------------------------------------------------------------------------------

N=length(nodes);

exist_best_nodes_instances=1;

%'---------------------------------------------------Test cap_max----------------------------------------------------'

%for instanes if the first cluster has 5 max instances the second 3 and the thirst 7
%then pos=3 1 2 and the number of tests at at most 5*7+ 3*7= 7(5+3)

s=0;
for i=1:length(sauv_max_index)
    s=s+length(sauv_max_index{i});
end

s=s-length(sauv_max_index{pos(N)}); 

p=length(sauv_max_index{pos(N)})*s;

cap_max=0;

if p > 200000000  %nb of tests at most but the pb is that it can be less 
    cap_max=1;
end

%'---------------------------------------------------if cap_max is not reached----------------------------------------------------'

if cap_max==0

treated_var=[];    %pour marquer les variables traitées

best_nodes_instances=[];

%'--------------------treatement of the cluster having the less number of values equal to max  (heuristic)----------------'

treated_node=pos(1);   

for i=1:length(sauv_max_index{treated_node})
    best_nodes_instances{i}=zeros(1,length(big_domain));
end

dom=clpot{nodes(treated_node)}.domain;
equiv_pos_dom=find_equiv_posns(dom, big_domain); %find the position of the variables in dom in big_domain

for i=1:length(sauv_max_index{treated_node})
    best_nodes_instances{i}([equiv_pos_dom])=[sauv_max_index{treated_node}{i}];
end  

treated_var=myunion(treated_var, dom); %to mark treated variables

%for i=1:length(best_nodes_instances)
 %     big=best_nodes_instances{i}
 %end 

%'-----------------treatment of the rest of nodes-----------------'
    
%in this procedure we are sure that we treat more than one node

if N>2  % there are more than one cluster 

pos_new_node=2;

next=1;

while (pos_new_node <= N) & (next==1)  %main loop

treated_node=pos(pos_new_node);

treated_coherent=0;    
   
dom=clpot{nodes(treated_node)}.domain;

equiv_pos_dom=find_equiv_posns(dom, big_domain);

%'----------------------Test Existe-------------------------'

if sum(ismember(dom,treated_var))==0
    treated=0;
else
    treated=1;
end

%'--------------------------------------------------------'

treated_var=myunion(treated_var, dom);

%'--------------------------------------------------------'

position_best_nodes_instances=1;

sauv_best_nodes_instances=best_nodes_instances;

nb_best_nodes_instances=length(best_nodes_instances) 

best_nodes_instances=[];

%'--------------------------------------------------------'

for i=1: nb_best_nodes_instances %1
   
    val_max_nodes=sauv_max_index{treated_node};  %contient les instances qui ont la valeur max dans treated_node
   
    length_val_max_nodes=length(val_max_nodes); %nb val max dans treated_node
        
    for j=1:length_val_max_nodes  %2
       
        % '-------------------------yes treated------------------------'

        if treated %3
        
        one_best_nodes_instances=sauv_best_nodes_instances{i};
        verif_index=[];
        verif_index=one_best_nodes_instances([equiv_pos_dom]);
        test_coherence=1;    %pour tester la coherence entre les var deja traitée
        k=1;
        
        while (k<= length(verif_index)) & (test_coherence==1) %4
            
           if verif_index(k)~=0
               val_1=verif_index(k); %la k eme valeur  a partir de big
               val_2=sauv_max_index{treated_node}{j}(k); %la k eme valeur dans l'instance max numero j relative a treated_node 
               test_coherence=(val_1==val_2);        
           end
           k=k+1;
        end %4

        %'-------------------------The instances are consistent-------------------'
        
        %if we exit with test_coherence==1 then we are sure that the treated instance is consistent

        if test_coherence==1

        best_nodes_instances{position_best_nodes_instances}=sauv_best_nodes_instances{i};
       
        best_nodes_instances{position_best_nodes_instances}([equiv_pos_dom])=[sauv_max_index{treated_node}{j}];
        
        position_best_nodes_instances=position_best_nodes_instances+1;
        
        treated_coherent=1;
        
        end
        
        else %(treated=0)
         
       %  '-------------------------Not treated------------------------'
            
        treated_coherent=1;
        
        best_nodes_instances{position_best_nodes_instances}=sauv_best_nodes_instances{i};

        best_nodes_instances{position_best_nodes_instances}([equiv_pos_dom])=[sauv_max_index{treated_node}{j}];
     
        position_best_nodes_instances=position_best_nodes_instances+1;
        
        end %if treated %3
    end %for j=1:length_val_max_nodes %2
end % for i=1:length(best_nodes_instances) %1   

if treated_coherent==0 % there are no consistent instances
    next=0;
    exist_best_nodes_instances=0;
          
end

pos_new_node=pos_new_node+1;

end

end

end