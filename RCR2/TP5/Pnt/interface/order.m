'----------'
      
order=[]
for i=1:nbn
    ps=parents(dag,i);
    if isempty(ps)
        order=[order i] 
    end
end

j=1;
for i=1:nbn
    if ~ismember(i,order)
    sauv_mat{j}=mat{i}; 
    j=j+1;
    end
end
mat=sauv_mat;


for i=1:length(mat)
    nn=mat{i}.name
    nnn=mat{i}.place
end


k=1;
%while ~isempty(mat)
     index=mat{k}.place;       
     ps=parents(dag,index);
     if sum(ismember(ps,order))==length(ps)
         order=[order index] 
     end
     
       %   j=1;
  %   for i=order
  %      sauv_mat{j}=mat{i};
  %      j=j+1;
  %   end
  %   mat=sauv_mat;
  %   k=k+1;
  %end
   

order
mat