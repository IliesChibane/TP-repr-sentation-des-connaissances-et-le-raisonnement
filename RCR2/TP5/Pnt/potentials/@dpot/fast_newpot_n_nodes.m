function [potcl, modif_pot]=fast_newpot_n_nodes(potcl,clpot, nodes, ns);
 

%supposons qu'on veut traiter le cluster AC avec ces deux nodes
%AB et BCD. Les separateurs sont A et C = AC. En supposant que les
%variables sont binaires AC a quatre instances ac, -ac,a-c,-a-c
%donc je prend ces instances une à une  en parcourant l'ensembles
%des nodes pour construire  les instances globales qui les
%contiennent et en calculant leur potentiel (en minimisant). Par
%exemple si on considère ac alors les instances globales sont abcd,
%a-bcd, abc-d, a-bc-d. A la fin je maximise sur toutes les
%instances globales pour calculer le potentiel de ac. Cette
%opération doit être répéter pour les 3 autres instances.

%'-------------------------------------------------------------------------------------------

%for i=1:length(nodes)
%    clpot{nodes(i)}.domain
%    clpot{nodes(i)}.T(:,:)
   
%end 



%et si un seul node!!!!!!!!!!!!!!!!!!!


save_pot=potcl.T;

treated_var=[];    %pour marquer les variables traitées

%'---------------------calcul des separateurs relatifs aux nodes ----------------------'

sep_nodes=[];

for i=1:length(nodes)
   
   sep_nodes=  myunion(sep_nodes, intersect(potcl.domain, clpot{nodes(i)}.domain));
   
end

big_matrix_sep=[];

big_matrix_sep=def_mat(ns(sep_nodes)); %big matrix relative to nodes(i)

p_sep_nodes = dpot(sep_nodes, ns(sep_nodes)); %to fix domain and size for separators

%'---------------------calcul de big_domain de tous les nodes----------------------'

big_domain=[];

for i=1:length(nodes)
   
   big_domain=  myunion(big_domain, clpot{nodes(i)}.domain);
   
end

%'---------------------Treatement of the instances of sep_nodes one by one----------------------'

for nb_instance_sep=1:length(big_matrix_sep) %1
    
big_instance=[];
    
max_value=0;    
    
val_onto =  big_matrix_sep(nb_instance_sep,:);  %one instance from big_matrix_sep

sauv_max_index=[];

%'---------------------calcul des instances contenant val_onto de chaque node----------------------'

for j=1:length(nodes) %2
    
big_matrix_node=[];

positions_node.instance=[];

positions_node.potential=[];

big_matrix_node=def_mat(clpot{nodes(j)}.sizes); %big matrix relative to nodes(i)

equiv_pos_dom_1=find_equiv_posns(sep_nodes, clpot{nodes(j)}.domain);

equiv_pos_dom_2=find_equiv_posns(clpot{nodes(j)}.domain,sep_nodes);

position=1;

for k=1:length(big_matrix_node)
    one_big_instance=big_matrix_node(k,:);
    val_index=one_big_instance([equiv_pos_dom_1]);
    inter_val_onto=val_onto([equiv_pos_dom_2]);
    if isequal(val_index,inter_val_onto)
        positions_node.instance{position}= big_matrix_node(k,:);
        positions_node.potential{position}=clpot{nodes(j)}.T(k);
        position=position+1;
    end
end    

sauv_max_index{j}=positions_node;

end %2

    
%for i=1:length(sauv_max_index)
 %   '==='
  %  sauv_max_index{i}
   % '===='
   %end
  
%'ici1'
%'--------------------traitement du premier node-----------------'


for i=1:length(sauv_max_index{1}.instance)
    big_instance{i}.instance=zeros(1,length(big_domain));
    big_instance{i}.potential=0;
end

dom=clpot{nodes(1)}.domain;
equiv_pos_dom=find_equiv_posns(dom, big_domain);


for i=1:length(sauv_max_index{1}.instance) 

    big_instance{i}.instance([equiv_pos_dom])=sauv_max_index{1}.instance{i};
    big_instance{i}.potential=sauv_max_index{1}.potential{i};
    max_value=max(max_value,big_instance{i}.potential);
    p_sep_nodes.T(nb_instance_sep)= max_value;
    
end    

treated_var=myunion(treated_var, dom);

%for i=1:length(big_instance)
 %     big1=big_instance{i}
 %end 

 
 %'ici2'

%'-----------------traitement des autres nodes-----------------'
    
next_node=2;

next=1;

while (next_node <= length(nodes)) & (next==1)

treated_coherent=0;    

    
dom=clpot{nodes(next_node)}.domain;
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

for i=1:length(big_instance)
    
    val_max_node=sauv_max_index{next_node};  %contient les valeur max dans next_node
   
    length_val_max_node=length(val_max_node.instance); %nb val max dans next_node
    
    for j=1:length_val_max_node
        
       % '-------------------------yes treated------------------------'
        if treated
        
        one_big_instance=sauv_big_instance{i}.instance;
        verif_index=[];
        verif_index=one_big_instance([equiv_pos_dom]);
        test_coherence=1;    %pour tester la coherence entre les var deja traitée
        k=1;

        while (k<= length(verif_index)) & (test_coherence==1)
           if verif_index(k)~=0
               %valk=k
               val_1=verif_index(k); %la k eme valeur  a partir de big
               val_2=sauv_max_index{next_node}.instance{j}(k); %la k eme valeur dans l'instance max numero j relative a next_node 
               test_coherence=(val_1==val_2);        
               treated_coherent=treated_coherent+test_coherence;
           end
           k=k+1;
        end

        %'-------------------------il ya coherence entre les instances-------------------'

        if test_coherence==1

        big_instance{position_big_instance}.instance=sauv_big_instance{i}.instance;
       
        big_instance{position_big_instance}.instance([equiv_pos_dom])=[sauv_max_index{next_node}.instance{j}];
        
        min_value=min(sauv_big_instance{i}.potential, sauv_max_index{next_node}.potential{j});        
        
        big_instance{position_big_instance}.potential=min_value;
        
        max_value=max(max_value,min_value); 
        
        p_sep_nodes.T(nb_instance_sep)= max_value;
        
        position_big_instance=position_big_instance+1;
        
        end
        
        else %treated=0
         
       %  '-------------------------Not treated------------------------'
            
        treated_coherent=1;

        big_instance{position_big_instance}.instance=sauv_big_instance{i}.instance;
       
        big_instance{position_big_instance}.instance([equiv_pos_dom])=[sauv_max_index{next_node}.instance{j}];
        
        min_value=min(sauv_big_instance{i}.potential, sauv_max_index{next_node}.potential{j});        
        
        big_instance{position_big_instance}.potential=min_value;
        
        max_value=max(max_value,min_value);    

        p_sep_nodes.T(nb_instance_sep)= max_value;
     
        position_big_instance=position_big_instance+1;
        
        end %if treated
    end
end

if treated_coherent==0
    next=0;
end


next_node=next_node+1;

end

%at this level big_instance contains the global distribution relative to the instance val_onto of the separators computed from the nodes

%for i=1:length(big_instance)
%      big=big_instance{i}
%end 
%max_value

end


potcl=minimize_by_pot(potcl, p_sep_nodes);
  
modif_pot=0;
  
if ~isequal(save_pot, potcl.T)
     modif_pot=1;
end;



