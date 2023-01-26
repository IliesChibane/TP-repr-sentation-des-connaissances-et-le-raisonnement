function [sauv_max_index, pos] = extract_best_instances(potcl, val_max, clpot,  ps);


%This procedure affects to each cluster its max instances for it and for its nodes (parents, children etc.).

%The following example corresponds to nargin==4
%For instance if the cluster AC has three adjacent nodes A, AB et CBD s.t. (the order of variables is important here we have A C B D) :
%- the potential of  AC is : ac=0.9 -ac=0 a-c=0.4 -a-c=0.9
%- the potential of  A is: a=0.9 -a=0.9
%- the potential of  AB is: ab=0.3 -ab=0.9 a-b=0.9 -a-b=0.2
%- the potential of  CBD is:cbd=0 -cbd=0 c-bd=0 -c-bd=0 cb-d=0.9 -cb-d=0.8 c-b-d=0 -c-b-d=0.9

%then the program generates:
%- ac et -a-c : as max instances in AC
%- a-c-b-d et -acb-d: as max instances in  ACBD (union des domaines de tous les clusters)
%- ac et -ac as max instances in the union of the separators(AC) from AC
%- a-c et -ac as max instances in  the union of the separators (AC) from ABCD

%Thus

%- for each cluster i we save its best instances in sauv_max_index{i} thus:
%* for  1 (i.e.  A): sauv_max_index{1}{1}= 1, sauv_max_index{1}{2}= 2
%* for  2 (i.e.  AB):sauv_max_index{2}{1}= 2 1, sauv_max_index{2}{2}= 1 2
%* for  3 (i.e.  CBD): sauv_max_index{3}{1}= 1 1 2, sauv_max_index{3}{2}= 2 2 2


%-----------------------------------------------------------------------------------------------------------------------------

sauv_max_index=[];
index_instances=[];

if nargin==2  %i.e. potcl and val_max
   
index_instances=find(potcl.T==val_max);   %index of values equal to max

big_matrix_cl=def_mat(potcl.sizes);

for i=1:length(index_instances)
  sauv_max_index{i}.val= big_matrix_cl(index_instances(i),:);
  sauv_max_index{i}.pos= index_instances(i);
end

%-----------------------------------------------------------------------------------------------------------------------------

else %i.e. potcl, val_max, clpot and ps

for i=1:length(ps)

index_instances=find(clpot{ps(i)}.T==val_max);    %index of values equal to max in ps(i)

big_matrix_parent=def_mat(clpot{ps(i)}.sizes); %big matrix relative to ps(i)

positions_parent=[];

for j=1:length(index_instances)
    positions_parent{j}= big_matrix_parent(index_instances(j),:);
end

sauv_max_index{i}=positions_parent;                   %instances having a potential equal 
sauv_size(i)=length(index_instances);

end

[val,pos]=sort(sauv_size);

end