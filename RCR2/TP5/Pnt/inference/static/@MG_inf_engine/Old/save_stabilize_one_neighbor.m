function [clpot]=stabilize_one_neighbor(engine,  clpot, C)


%The stabilization at one-neighbor is the classical one where each cluster ensures its stability with respect to each of its
%neighbors. In this procedure, messages are passed, from the first cluster to the last one, until reaching stability (i.e stable=1). 

%'----------------------------------------------------------------------------------------------------------------------------'


seppot = cell(C, C);
sauvpot = cell(C, C);
stable=0;


while stable==0	%1
    

% '-------------------------------One cycle----------------------------------'

 for i=C:-1:1 		%2 			% treatment of all clusters
   for j=(i-1):-1:1		%3 	% verification of each cluster i with others (i-1.. 1)
      if ~isempty (engine.separators{j,i}) 	%4 	% to respect the separators matrix indexes
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

%		clpot{j} = minimize_by_pot(clpot{j}, marginalize_pot(clpot{i}, engine.separators{j,i})); 

      end  %4
   end     %3
end        %2



 

 
test=1;
i=1;
while (i<=C) & (test==1) %8 			% treatment of all clusters
   j=i+1;
   while (j<=C) & (test==1)	    %9 % verification of each cluster i with others (i+1.. C)
        
      if ~isempty (engine.separators{i,j}) %10
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

%for i=1:C
%affiche(clpot{i})
%end



%alpha_stable=maximum_value(clpot{1},C)
%for i=2:C
%   v=maximum_value(clpot{i},C);
%   if v~=alpha_stable
      %stability=0;
%      'pbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb in stabilize_one_neighbor'
%  end
%end

