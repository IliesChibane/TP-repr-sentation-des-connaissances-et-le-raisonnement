 function best_instances=define_best_instances(potcl,clpot, N, Poss_degree);  %potcl inutile

 
best_instances=[];
 
for i=1:N
        affiche(clpot{i})
        cluster_matrix=def_mat(clpot{i}.sizes);
        index_best_instances = find(clpot{i}.T==Poss_degree);
        
        instances= [];
        for j=1:length(index_best_instances)
            big_instance=cluster_matrix(index_best_instances(j),:);
            var_instance=big_instance(length(big_instance));
            if ~ismember(var_instance, instances)
                instances=[instances var_instance];
            end
        end
        instances
        best_instances{i}= instances;

end