function [clpot]=one_node_stability(engine,  pnet, clpot, C)

%This procedure ensures that any cluster agree with each of its neighbors on the
%distributions defined on common variables. The order in which messages circulate during the stabilization procedure depends on
%the topological order of the variables since each cluster $C_i$ communicates with its adjacent clusters in $\{C_{i-1}, .., C_1\}$.
%This process starts with the cluster $C_N$ and will be repeated until reaching the stability (i.e \emph{stable}=1).
%'----------------------------------------------------------------------------------------------------------------------------'

seppot = cell(C, C);
sauvpot = cell(C, C);
stable=0;

while stable==0	%1

 %'-------------------------------One cycle----------------------------------'

 for i=C:-1:1 		%2 			% treatment of all clusters
  
   for j=(i-1):-1:1
       if ~isempty(engine.separators{j,i})
   
 %     '-------------------------------sep first cycle--------------------------'

      % minimize_by_pot doit respecter la taille des potentiels c'est pourquoi il faut faire une minimization 
      % entre le potentiel du separateur(j,i) et le cluster(i) une marginalization, puis une entre 
      % le potentiel du separateur(j,i) et le cluster(j) suivie d'une marginalization
     
      %............................COLLECT EVIDENCE........................
      
      seppot{j, i}=marginalize_pot(clpot{i}, engine.separators{j,i});
      sauvpot{j, i}=seppot{j,i};
      seppot{j , i}=marginalize_pot(clpot{j}, engine.separators{j,i});
      seppot{j, i}=minimize_by_pot(sauvpot{j,i}, seppot{j,i});
   
      %............................DISTRIBUTE EVIDENCE........................
      
      clpot{i} = minimize_by_pot(clpot{i}, seppot{j,i}); 
      clpot{j} = minimize_by_pot(clpot{j}, seppot{j,i}); 
      end

  end     %3
end        %2


%----------------------Testing stability-----------------------

test=1;
i=1;
while (i<=C) & (test==1) %8 			% treatment of all clusters

   for j=(i+1):C
   
      if ~isempty(engine.separators{i,j}) %10
        seppot{i,j}=marginalize_pot(clpot{i}, engine.separators{i,j});
      sauvpot{i,j}=seppot{i,j};
      seppot{i,j}=marginalize_pot(clpot{j}, engine.separators{i,j});
      equal=test_equality(sauvpot{i,j},seppot{i,j});
      if equal==0
         test=0;
      end
      end %10
      j=j+1;
   end %9
i=i+1;   
end %8

if (test==1) 
stable=1;
end

end %1

%alpha_stable=maximum_value(clpot{1},C);
%for i=2:C
%   v=maximum_value(clpot{i},C);
%   if v~=alpha_stable
%      stability=0;
%      'pbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb in one_parent_stability'
%  end
%end


