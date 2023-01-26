nblevel=6;

levels=[12 34 23 10];

for level=1:(length(levels)-1)

%==============================Random generation of the DAG structure============================

N_level_one=levels(level); 				% roots number                          	
N_level_two=levels(level+1);  	    	% number of the rest of variables   		

N_child_max=5;  				% number max of children                    	

N = N_level_one+N_level_two;

for nb_exemple=1:1  % number of example
   
   '------------------One Example-----------------------------------'
 
   dag = zeros(N,N);
    
   for i=1:N_level_one    
   
   N_child=randperm(N_child_max); 	    	%to fix the children number
   N_c=N_child(1);   							%the effective number of children      
   %fix the list of possible children
   L_poss_child_final=[];
   L_poss_child=randperm(N);
   j=1;
   
   for l=1:length(L_poss_child);
      if L_poss_child(l) >= (N_level_one+1)
         L_poss_child_final(j)=L_poss_child(l);
         j=j+1;
      end
   end   
   
   list_child=[];
   
   if i ~= 1
      dag(i,last_child)=1;
   end

   for k=1:N_c      
      list_child(k)=L_poss_child_final(k);
   end
   
   last_child=list_child(N_c);

   dag(i,list_child)=1;
  
end

for i=(N_level_one+1):N
   ps=parents(dag,i);
   if isempty(ps)      
     N_parent=randperm(N_level_one);    
     N_p=N_parent(1);   
     dag(N_p,i)=1;
  end
end;

%to form loops
set= N_level_one+div(N_level_two,2)+1;
decalage=div(N_level_two,2);

if decalage ~= 0
for i=set:N
   dag(i-decalage,i)=1;
end;
end;

ps=parents(dag,1);
for i=2:N
    if length(parents(dag,i))> length(ps)
        ps=parents(dag,i);
    end
end

nb_parent_max=length(ps)

nodes = 1:N;

for node=1:N
   if mod(node,2)==0
      node_sizes(node) = 2;
   else
      node_sizes(node) = 3;
   end
end

pnet = mk_pnet(dag, node_sizes, nodes);

