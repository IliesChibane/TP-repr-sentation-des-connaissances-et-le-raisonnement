nbequal=0;

%generation aléatoire du DAG

Nrootnodes=30; 			% roots number                          50
Nrest=70;  			    % number of the rest of variables   100
N_child_max=2;  		% number of children                    20

N = Nrootnodes+Nrest;

for nb_exemple=1:100  % number of example
   
   '------------------One Example-----------------------------------'
 
   dag = zeros(N,N);
    
   for i=1:Nrootnodes    
   
   N_child=randperm(N_child_max); 	    %pour fixer le nb d'enfants
   N_c=N_child(1);   					%c'est le nb d'enfant qu'on va choisir
      
   %fixer la liste des enfants possibles
   L_poss_child_final=[];
   L_poss_child=randperm(N);
   j=1;
   
   for l=1:length(L_poss_child);
      if L_poss_child(l) >= (Nrootnodes+1)
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

for i=(Nrootnodes+1):N
   ps=parents(dag,i);
   if isempty(ps)      
     N_parent=randperm(Nrootnodes);    
     N_p=N_parent(1);   
     dag(N_p,i)=1;
  end
end;

%pour former des boucles

set= Nrootnodes+div(Nrest,2)+1;
decalage=div(Nrest,2);

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
node_sizes = 2*ones(1,N);
pnet = mk_pnet(dag, node_sizes, nodes);

%generation aléatoire d'une distribution discrete

for d=1:N
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
  l=length(ps);
  
  if l==0  
     x=rand(1);
     distribution = [x 1]; %generation of a distribution with a max degree equal to 1
  else 
     
     j=(2^l)*2; % nb of values in the distribution (with binary variables)     
     k=div(j,2);
     
  for i=1:k
     x=rand(1);
     
     if x<0.15
         x=0; 
     end
     
     % if i is odd then assign x to the first value and 1 to the second
     % else assign 1 to the first value and x to the second

     if mod(i,2)==0
      distribution(i) = x;
      sauv(i) =1;
     else
      distribution(i) = 1;
      sauv(i) =x;
     end
  
  end
    
  s=1;
  for i=(length(distribution)+1):j
     distribution(i) = sauv(s);
     s=s+1;
  end
  
  end %if
 
 pnet.CPD{d} = tabular_CPD(pnet, d, distribution);
 
end % grand for

evidence = cell(1,N);

var=randperm(N);
var_evidence1=var(1);            % relative à une evidence
var_evidence2=var(2);            % relative à une evidence

instance=randperm(2);     % pour choisir la première ou la deuxième valeur
instance_evidence1=instance(1);
instance_evidence2=instance(2);

evidence{var_evidence1} = instance_evidence1;  
evidence{var_evidence2} = instance_evidence2;  

var_interest=var(4);

disp('----------------nouveau-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new] = enter_evidence(engine, evidence, var_interest); toc;

Bel_Cdt=Bel_Cdt_new

disp('----------------classique-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = enter_evidence(engine, evidence);toc;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T

equal=1;

if ~isequal(Bel_Cdt_new, BEL_Cdt_classique)
   equal=0;
end;


nbequal=nbequal + equal;

end
nb=nbequal