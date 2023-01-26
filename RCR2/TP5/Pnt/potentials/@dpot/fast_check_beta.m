function [consistency]=fast_check_beta(pot_parents,clpot,ns,parent_clusters,alpha);

%This procedure allows to check if it is necessary to add links between clusters to save the degree beta 
%by testing if this degree already exists in the parent clusters 
%Principle: 
%1) we detect inconsistent instances of parents coputed from the treated cluster: inconsistent_index. Their potential is denoted beta.
%2) we compute the potential of this instance from parents starting by the first parent 
%3) we compare this potential (beta_from_parents) 
%If we have equality between beta_from_parents and beta for all the inconsistent instances, 
%then the cluster is consistent and it is useless to add links between its parents to save the degree beta


%pot_parents: the potential of parents 
%clpot{i}: contains the domain, the size and the potential of the cluster i
%ns: node sizes
%parent_clusters: the parent clusters
%alpha: the degree alpha

%'--------------------------------------------------------------------------------------'


%pot_parents.T(:,:)
%parent_clusters
%for i=1:length(parent_clusters)
%    clpot{parent_clusters(i)}.T(:,:)
%    clpot{parent_clusters(i)}.domain
%end

%'--'

consistency=1;

big_matrix_parents=[];

big_matrix_parents=def_mat(ns(pot_parents.domain)); %big matrix relative to parents

treated_var=[];  

inconsistent_index=find(pot_parents.T~=alpha); %inconsistent instances

%'---------------------Computing big_domain relative to parents clusters----------------------'

big_domain=[];

for i=1:length(parent_clusters)
   
   big_domain=  myunion(big_domain, clpot{parent_clusters(i)}.domain);
   
end

%'---------------------Treatement of the instances in inconsistent_index one by one----------------------'

nb_inconsistent_instance=1;

while (nb_inconsistent_instance <= length(inconsistent_index)) & (consistency==1)           %1
    
inconsistent_instance=big_matrix_parents(inconsistent_index(nb_inconsistent_instance),:);

beta=pot_parents.T(inconsistent_index(nb_inconsistent_instance));

sauv_max_index=[];
big_instance=[];
max_value=0;    

for j=1:length(parent_clusters) 

big_matrix_parent=[];

positions_parent.instance=[];

positions_parent.potential=[];

%'-----------------------------------------------------------------------------------------------------

big_matrix_one_parent=def_mat(clpot{parent_clusters(j)}.sizes); %big matrix relative to parent_clusters(i)

equiv_pos_dom_1=find_equiv_posns(pot_parents.domain, clpot{parent_clusters(j)}.domain);  %the var in pot_parents.domain existing in  clpot{parent_clusters(j)}.domain

equiv_pos_dom_2=find_equiv_posns(clpot{parent_clusters(j)}.domain,pot_parents.domain);   %the var in clpot{parent_clusters(j)}.domain existing in pot_parents.domain

inter=big_matrix_one_parent(:,equiv_pos_dom_1(1))==inconsistent_instance([equiv_pos_dom_2(1)]);

for a=2:length(equiv_pos_dom_1)
    inter=inter & (big_matrix_one_parent(:,equiv_pos_dom_1(a))==inconsistent_instance([equiv_pos_dom_2(a)]));
end

pos_inter=find(inter==1);

positions_parent.instance=big_matrix_one_parent(pos_inter,:);

positions_parent.potential=clpot{parent_clusters(j)}.T(pos_inter);

sauv_max_index{j}=positions_parent;

%'-----------------------------------------------------------------------------------------------------

end %2

%for i=1:length(sauv_max_index)
%    '==='
%    sauv_max_index{i}
%    '===='
%end
  
%'----------------initialization de big instance en utilisant le premier neighbor-------------------'

for i=1:length(sauv_max_index{1}.instance)
    big_instance{i}.instance=zeros(1,length(big_domain));
    big_instance{i}.potential=0;
end

%'--------------------traitement du premier neighbor-----------------'

dom=clpot{parent_clusters(1)}.domain;
equiv_pos_dom=find_equiv_posns(dom, big_domain);

for i=1:length(sauv_max_index{1}.instance) 
    big_instance{i}.instance([equiv_pos_dom])=sauv_max_index{1}.instance(i,:);
    big_instance{i}.potential=sauv_max_index{1}.potential(i);
    beta_from_parents=max(max_value,big_instance{i}.potential);     %usefull if the cluster has just one parent
end    

treated_var=myunion(treated_var, dom);

%'-----------------traitement des autres neighbors-----------------'
    
next_parent_cluster=2;

next=1;

while (next_parent_cluster <= length(parent_clusters)) & (next==1)

treated_coherent=0;    

    
dom=clpot{parent_clusters(next_parent_cluster)}.domain;
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

position_big_instance=1;

sauv_big_instance=big_instance;

for i=1:length(big_instance) %1
    
    val_max_parent=sauv_max_index{next_parent_cluster};  %contient les valeur max dans next_parent_cluster
    
    [l,c]=size(val_max_parent.instance); %nb val max dans next_parent_cluster
    
   
    for j=1:l %2
        
       
       % '-------------------------yes treated------------------------'
        if treated
        
        one_big_instance=sauv_big_instance{i}.instance;
        verif_index=[];
        verif_index=one_big_instance([equiv_pos_dom]);
        test_coherence=1;    %pour tester la coherence entre les var deja traitée
        k=1;
        
        while (k<= length(verif_index)) & (test_coherence==1)
           if verif_index(k)~=0

              
               val_1=verif_index(k); %la k eme valeur  a partir de big
               
               a=sauv_max_index{next_parent_cluster}.instance(j,:);
               
               val_2=a(k); %la k eme valeur dans l'instance max numero j relative a next_parent_cluster 

               test_coherence=(val_1==val_2);        
               
               treated_coherent=treated_coherent+test_coherence;
               
           end
           k=k+1;
        end
        

        %'-------------------------il ya coherence entre les instances-------------------'

        if test_coherence==1
            
        big_instance{position_big_instance}.instance=sauv_big_instance{i}.instance;
       
        big_instance{position_big_instance}.instance([equiv_pos_dom])=[sauv_max_index{next_parent_cluster}.instance(j,:)];
        
        min_value=min(sauv_big_instance{i}.potential, sauv_max_index{next_parent_cluster}.potential(j));        
        
        big_instance{position_big_instance}.potential=min_value;
        
        beta_from_parents=max(max_value,min_value); 
        
        position_big_instance=position_big_instance+1;
        
        end
        
        else %treated=0
         
       %  '-------------------------Not treated------------------------'
            
        treated_coherent=1;

        big_instance{position_big_instance}.instance=sauv_big_instance{i}.instance;
       
        big_instance{position_big_instance}.instance([equiv_pos_dom])=[sauv_max_index{next_parent_cluster}.instance(j,:)];
        
        min_value=min(sauv_big_instance{i}.potential, sauv_max_index{next_parent_cluster}.potential(j));      
        
        big_instance{position_big_instance}.potential=min_value;
        
        beta_from_parents=max(max_value,min_value);    

        position_big_instance=position_big_instance+1;
        
        end %if treated
    end %2
end% 1

if treated_coherent==0
    next=0;
end


next_parent_cluster=next_parent_cluster+1;

end 

%a ce niveau j'ai traité une instance et je peux tester le beta
if beta_from_parents~=beta

    consistency=0;
    
end
    
nb_inconsistent_instance=nb_inconsistent_instance+1;

end %1
