function [potcl, decrease]=newpot_n_neighbors_min(potcl,clpot, neighbors,ns);



%Cette procedure donne pour chaque cluster les instances max pour lui et pour ses neighbors.
%Par exemple si le cluster AC a trois neighbors A, AB et CBD tel que (l'ordre des variables est important pour comprendre la suite
%donc juste note que je place C avant B mais c'est juste une notation) :
%- le potentiel de AC est : ac=0.9 -ac=0 a-c=0.4 -a-c=0.9
%- le potentiel de A est: a=0.9 -a=0.9
%- le potentiel de AB est: ab=0.3 -ab=0.9 a-b=0.9 -a-b=0.2
%- le potentiel de CBD:cbd=0 -cbd=0 c-bd=0 -c-bd=0 cb-d=0.9 -cb-d=0.8 c-b-d=0 -c-b-d=0.9

%le programme donne:
%- ac et -a-c : comme instances max dans AC
%- a-c-b-d et -acb-d: comme instances max dans ACBD (union des domaines de tous les clusters)
%- ac et -ac comme instances max de l'union des separateurs (AC) à partir de AC
%- a-c et -ac comme instances max de l'union des separateurs (AC) à partir de ABCD

%pour la construction du produit cartésien je suit a peu pres cette démarche:
%- je prend chaque cluster i et je sauvegarde ses instances maximales dans sauv_max_index{i} donc:
%* pour le neighbor 1 (c.a.d A): sauv_max_index{1}{1}= 1, sauv_max_index{1}{2}= 2
%* pour le neighbor 2 (c.a.d AB):sauv_max_index{2}{1}= 2 1, sauv_max_index{2}{2}= 1 2
%* pour le neighbor 3 (c.a.d CBD): sauv_max_index{3}{1}= 1 1 2, sauv_max_index{3}{2}= 2 2 2
%- je commence par le premier neighbor et je sauvegarde ses instances max  (à partir de sauv_max_index{1}) dans une
%matrice que j'appelle big_instance et qui a la taille de l'union des variables de tous les neighbors

%- Avec notre exemple le premier neighbor que je traite est A et donc :
%* big_instance{1}= 1 0 0 0   % c.a.d la variable A est à
%l'instance 1 et les autres ne sont pas encore instanciées
%* big_instance{2}= 2 0 0 0 %c.a.d la variable A est à
%l'instance 2 et les autres ne sont pas encore instanciées

%- je sauvegarde big_instance dans dans sauv_big_instance et je la réinitialise à vide
%- je considere le reste des neighbors en testant a chaque fois avant de rajouter des instances la coherence avec les instances deja sauvegardées dans big_instance
%-Avec notre exemple:
%* Le deuxième neighbor que je traite est AB et donc je teste si les instances de A deja sauvegardées dans big_instance sont coherente avec celles de AB
%* je teste sauv_big_instance{1}= 1 0 0 0 avec sauv_max_index{2}{1}= 2 1 : pas de coherence
%* je teste sauv_big_instance{1}= 1 0 0 0 avec sauv_max_index{2}{2}= 1 2 :  coherence donc big_instance{1}= 1 0 2 0
%* je teste sauv_big_instance{2}= 2 0 0 0 avec sauv_max_index{2}{1}= 2 1 : coherence donc big_instance{2}= 2 0 1 0
%* je teste sauv_big_instance{2}= 2 0 0 0 avec sauv_max_index{2}{2}= 1 2 :  pas de coherence

%- le troisième neighbor que je traite est CBD et donc je teste si les instances de B deja sauvegardées dans big_instance sont coherente avec celles de CBD
%* je teste sauv_big_instance{1}= 1 0 2 0 avec sauv_max_index{3}{1}= 1 1 2 : pas de coherence
%* je teste sauv_big_instance{1}=  1 0 2 0 avec sauv_max_index{3}{2}= 2 2 2 :  coherence donc big_instance{1}= 1 2 2 2
%* je teste sauv_big_instance{2}= 2 0 1 0 avec sauv_max_index{3}{1}= 1 1 2 : coherence donc big_instance{2}= 2 1 1 2
%* je teste sauv_big_instance{2}= 2 0 1 0 avec sauv_max_index{3}{1}= 1 1 2  : pas de coherence

%- A la fin on a les deux instances max: big_instance{1}= 1 2 2 2, big_instance{2}= 2 1 1 2 qui correspondent à: a-c-b-d et -acb-d


   scale=[];
           
   for nn=1:length(neighbors)
    for ll=1:prod(clpot{neighbors(nn)}.sizes)
       if ~ismember(clpot{neighbors(nn)}.T(ll), scale)
       scale=[scale,clpot{neighbors(nn)}.T(ll)];
       end
       scale=sort(scale);
    end
   end

 decrease=0;  

%'--------------------------------------------------------------------------------------'

treated_var=[];    %pour marquer les variables traitées

big_instance=[];

sauv_max_index=[];

index_clusters=[];

%'---------------------calcul des instances max de chaque neighbor----------------------'

for i=1:length(neighbors)

val_max=max(max(clpot{neighbors(i)}.T(:,:)));           %max val in neighbor i

index_neighbor=find(clpot{neighbors(i)}.T==val_max);    %index of values equal to max in neighbors(i)

big_matrix_neighbor=def_mat(clpot{neighbors(i)}.sizes); %big matrix relative to neighbors(i)

positions_neighbor=[];

for j=1:length(index_neighbor)
    positions_neighbor{j}= big_matrix_neighbor(index_neighbor(j),:);
end

sauv_max_index{i}=positions_neighbor;                   %instances having a potential equal 
sauv_size(i)=length(index_neighbor);

end

[val,pos]=sort(sauv_size);


%'---------------------calcul de big_domain de tous les neighbors----------------------'

big_domain=[];

for i=1:length(neighbors)
   
   big_domain=  myunion(big_domain, clpot{neighbors(i)}.domain);
   
end

%'--------------------traitement du premier neighbor-----------------'

treated_neighbor=length(neighbors);

for i=1:length(sauv_max_index{pos(treated_neighbor)})
    big_instance{i}=zeros(1,length(big_domain));
end


dom=clpot{neighbors(pos(treated_neighbor))}.domain;
equiv_pos_dom=find_equiv_posns(dom, big_domain);

for i=1:length(sauv_max_index{pos(treated_neighbor)})

    big_instance{i}([equiv_pos_dom])=[sauv_max_index{pos(treated_neighbor)}{i}];

end    

treated_var=myunion(treated_var, dom);

%'j ai termine le premier neighbor'

%for i=1:length(big_instance)
 %     big=big_instance{i}
 %end 

%'-----------------traitement des autres neighbors-----------------'
    
%dans cette procedure on est sur qu'on aplus qu'un neighbor

pos_new_neighbor=length(neighbors)-1;
next_neighbor=pos(pos_new_neighbor);

next=1;

while (pos_new_neighbor >= 1)) & (next==1)

treated_coherent=0;    

    
dom=clpot{neighbors(next_neighbor)}.domain;
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
    
    val_max_neighbor=sauv_max_index{next_neighbor};  %contient les valeur max dans next_neighbor
   
    length_val_max_neighbor=length(val_max_neighbor); %nb val max dans next_neighbor
    
    for j=1:length_val_max_neighbor
        
       % '-------------------------yes treated------------------------'
        if treated
        
        one_big_instance=sauv_big_instance{i};
        verif_index=[];
        verif_index=one_big_instance([equiv_pos_dom]);
        test_coherence=1;    %pour tester la coherence entre les var deja traitée
        k=1;

        
        while (k<= length(verif_index)) & (test_coherence==1)
           if verif_index(k)~=0
               %valk=k
               val_1=verif_index(k); %la k eme valeur  a partir de big
               val_2=sauv_max_index{next_neighbor}{j}(k); %la k eme valeur dans l'instance max numero j relative a next_neighbor 
               test_coherence=(val_1==val_2);        
           end
           k=k+1;
        end

        %'-------------------------il ya coherence entre les instances-------------------'
        %si on sort avec test_coherence==1 on est sur que l'instance traité est cohérente

        if test_coherence==1

        big_instance{position_big_instance}=sauv_big_instance{i};
       
        big_instance{position_big_instance}([equiv_pos_dom])=[sauv_max_index{next_neighbor}{j}];
        
        position_big_instance=position_big_instance+1;
        
        treated_coherent=1;
        
        end
        
        else %treated=0
         
       %  '-------------------------Not treated------------------------'
            
        treated_coherent=1;
        big_instance{position_big_instance}=sauv_big_instance{i};
        big_instance{position_big_instance}([equiv_pos_dom])=[sauv_max_index{next_neighbor}{j}];
     
        position_big_instance=position_big_instance+1;
        
        end %if treated
    end
end

if treated_coherent==0 %c'est à dire qu'il n'ya aucune instance cohérente
    next=0;
end


pos_new_neighbor=pos_new_neighbor-1;

if  pos_new_neighbor >= 1
   next_neighbor=pos(pos_new_neighbor);
end

end

%'---------------------calcul de onto--------------------'

onto=[];

for i=1:length(neighbors)
   
   onto=  myunion(onto, intersect(potcl.domain, clpot{neighbors(i)}.domain));
   
end

%'-------------------Extraction de dom a partir de big_instance------------'

equiv_pos_dom_onto=find_equiv_posns(onto, big_domain);

position_small_instance=1;

small_instance=[];

for i=1:length(big_instance)

        if length(find(big_instance{i}))==length(big_instance{i}) %instance complete
            
        j=1;
        my_test=0;
        while j<=length(small_instance) & my_test==0
            if isequal(small_instance{j},big_instance{i}(equiv_pos_dom_onto))
                my_test=1;
            end
            j=j+1;
        end
        
        if my_test==0  
        
                    small_instance{position_small_instance}=big_instance{i}(equiv_pos_dom_onto);
        
                    position_small_instance=position_small_instance+1;
         end
        
         end
    
end

%'-------------------------affichage--------------------'

  %big_d=big_domain
  %for i=1:length(big_instance)
  %    big=big_instance{i}
  %end 

  %on=onto
  
  %for i=1:length(small_instance)
  %    small=small_instance{i}
  %end

%'----------------------les indices des val max dans potcl---------------'

val_max=maximum_value(potcl);           %max val 

index_cl=find(potcl.T==val_max);   %index of values equal to max

big_matrix_cl=def_mat(potcl.sizes);

sauv_max_index_cl=[];

for i=1:length(index_cl)
  sauv_max_index_cl{i}.val= big_matrix_cl(index_cl(i),:);
  sauv_max_index_cl{i}.pos= index_cl(i);
end

%'-------------------Extraction de dom a partir de potcl-------------------------'

equiv_pos_dom_onto=find_equiv_posns(onto, potcl.domain);

position_small_instance=1;

small_instance2=[];

for i=1:length(sauv_max_index_cl)

        j=1;
        my_test=0;
        while j<=length(small_instance2) & my_test==0
            if isequal(small_instance2{j}.val,sauv_max_index_cl{i}.val(equiv_pos_dom_onto))
                my_test=1;
            end
            j=j+1;
        end
        
           
        if my_test==0        
                
 
        small_instance2{position_small_instance}.val=sauv_max_index_cl{i}.val(equiv_pos_dom_onto);
        
        small_instance2{position_small_instance}.pos=sauv_max_index_cl{i}.pos;
            
        position_small_instance=position_small_instance+1;
        
        end
        
end

%'-----------------------Affichage-------------------------'

%for i=1:length(small_instance)
%      small_big=small_instance{i}
%  end

% for i=1:length(small_instance2)
%      small_cl=small_instance2{i}
%  end
 
 %'-----------------------test-------------------------'

pos_incoherent_instance=1;
not_coherent=[];
for i=1:length(small_instance2)
    j=1;
    my_test=0;
    while j<=length(small_instance) & my_test==0
       
        if  isequal(small_instance{j},small_instance2{i}.val) %existe 
           my_test=1;
        end
        j=j+1;
    end
    
    
      
    if my_test==0
             not_coherent(pos_incoherent_instance)=small_instance2{i}.pos;
             pos_incoherent_instance=pos_incoherent_instance+1;
    end

end

if ~isempty(not_coherent)
    
  
x=find(scale==val_max);

if x~=1
    potcl.T(not_coherent)=scale(x-1);
    decrease=1;
end

  
end
    
