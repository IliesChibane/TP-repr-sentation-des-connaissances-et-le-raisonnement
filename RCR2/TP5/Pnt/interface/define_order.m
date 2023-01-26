global dag mat


  
order=[];
for i=1:nbn
    ps=parents(dag,i);
    if isempty(ps)
        order=[order mat{i}];
    end
end

place_order=[];
for i=1:length(order)
    place_order=[place_order order(i).place];
end

j=1;
for i=1:nbn
    if ~ismember(i,place_order)
    sauv_mat{j}=mat{i}; 
    j=j+1;
    end
end


k=1;
while ~isempty(sauv_mat)
     index=sauv_mat{k}.place;    
     
     ps=parents(dag,index);
     
     if sum(ismember(ps,place_order))==length(ps)
         order=[order sauv_mat{k}]; 
   
     place_order=[];
     
     for i=1:length(order)
        place_order=[place_order order(i).place];
     end

%je veut enlever index de sauv_mat     
     
j=1;
sauv_mat2=[];

for i=1:length(sauv_mat)
    if ~isequal(sauv_mat{i}.place,index)
    sauv_mat2{j}=sauv_mat{i}; 
    j=j+1;
    end
end
sauv_mat=sauv_mat2; 
else
    sauv=sauv_mat{k};
    sauv_mat(1:length(sauv_mat)-1)=sauv_mat(2:length(sauv_mat));
    sauv_mat{length(sauv_mat)}=sauv;
    
end    
end

%--------------------------------------------------------------------

for i=1:length(order)
    mat{i}=order(i)
end

%--------------------------------------------------------------------

dag2=zeros(nbn,nbn);

for i=1:nbn
    the_node=mat{i}.place;
    cs=children(dag,the_node);
    dag2(the_node,cs) = 1;
end
dag=dag2;

%----------------------------------------------------------------------



