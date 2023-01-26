

function [index_vector] = def_marg(dom,dom_onto, ndx, inconsistent_instance)

big_matrix=def_mat(dom);
small_matrix=def_mat(dom_onto);
index_inconsistent_instance=[];

index_vector=[];

for column=1:length(dom_onto)
   index_inconsistent_instance=[index_inconsistent_instance small_matrix(inconsistent_instance, column)];
end
 
for i=1:prod(dom) %nb line in big_matrix
   
   test=1;
   j=1;
   cpt=0;
   
   while j <=length(index_inconsistent_instance) & (test==1)
      
      if (big_matrix(i,ndx(j))==index_inconsistent_instance(j)) & (test==1)
         cpt=cpt+1;
      else
         test=0;
      end
      j=j+1;
   end
   
   if cpt==length(index_inconsistent_instance)
      index_vector=[index_vector i];
   end
   
   
  
end
