%'--------------------------------------------------------'

 %  for i=1:length(big_instance)
 %     big=big_instance{i}
 % end 
   
%'-------------------Test de la procedure--------------------'
    
%size_max_neighbors=length(big_domain)

p_inter = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes

p_inter.T= extend_domain_table(clpot{neighbors(1)}.T, clpot{neighbors(1)}.domain, clpot{neighbors(1)}.sizes, p_inter.domain, p_inter.sizes);

potential=p_inter;
   
for i=1:length(neighbors)
  
  p_inter.T = extend_domain_table(clpot{neighbors(i)}.T, clpot{neighbors(i)}.domain, clpot{neighbors(i)}.sizes, p_inter.domain, p_inter.sizes);
   
  potential.T=min(potential.T, p_inter.T);
   
end

%'--------------------------------------------------------'

val_max=max(max(potential.T(:,:)));           %max val in neighbor i

index_neighbor=find(potential.T==val_max);  %index of values equal to max

big_matrix_neighbor=def_mat(ns(big_domain));

sauv_max_index=[];

for i=1:length(index_neighbor)
    sauv_max_index{i}= big_matrix_neighbor(index_neighbor(i),:);
end


%'--------------------------Fin 2-------------------------'

i=1;

big_test=1;

one_time=0;

while (i<=length(big_instance)) & (big_test==1)

    small_test=0;
    
    if length(find(big_instance{i}))==length(big_instance{i})
        
    one_time=1;
    
    for j=1:length(sauv_max_index)
        
        if isequal (big_instance{i}, sauv_max_index{j})
            small_test=1;
        end
    end
    
    if small_test==0
        big_test=0;
    end
    
    end

    i=i+1;
end


if (big_test==0) | (one_time==0 & ~isempty(sauv_max_index))
        
'pbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'

end
    

%'--------------------------------------------------------'




