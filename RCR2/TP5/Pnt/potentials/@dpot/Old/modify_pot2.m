function newpot=modify_pot2(oldpot, ps, alpha);

%ancienne procedure


%ns = zeros(1, max(oldpot.domain));
%ns(oldpot.domain) = oldpot.sizes;

%dom = oldpot.domain;  					  % old domain of the cluster
%max_over = mysetdiff(dom, ps); 		  % the variable relative to the cluster (child) (set of all variable - parents)
%ndx = find_equiv_posns(max_over, dom); % position of max_over(child) in dom 

inter=marginalize_pot(oldpot, ps); %inter contains the potential relative to ps

A=sparse(inter.T(:,:)); 

[i,j]=find(A~=alpha); 
% i contient les numeros de lignes et j les numeros des colonnes 
% des valeurs differentes de alpha dans la distributions jointe relatives aux parents


[line_parents,column_parents]=size(inter.T);  %size of parents distribution
[line_oldpot,comlumn_oldpot]=size(oldpot.T);  %size of the cluster distribution 

%newpot = dpot(ps, ns(ps)); 
newpot = oldpot;

nb_value_beta=length(i);  %or length(j) = nb of values in inter which are < alpha

for v=1:nb_value_beta
      line=i(v);
      column=j(v);
      
      % Principle of searching the position of beta for the instance [line, column] of parents
      % we consider that the max is the first element relative to the parent instanciation 
      % for instance if i=[1 2 1] j=[1 1 2] then the instances 11, 21, 12 of parents are inconsistent
      % In order to search beta (to replace it by alpha) for the instance 21 we start in oldpot at position [line, column] and we maximize in the same line (i.e 2) 
      % since the maximization will be always performed  on lines. Indeed we maximize on the child and this child is always in the last position
      % The maximimization is performed at the same line but we shoud jump up in colums by the possible configurations of parents in the same line (i.e column_parents)

      val_max=oldpot.T(line,column);      
      pos_max=[line, column];
      current_pos=pos_max;
      while column <= comlumn_oldpot    %we should not take <= but <
         if oldpot.T(line,column)> val_max
            val_max=oldpot.T(line,column);
            pos_max=current_pos;
         end
         column=column+column_parents; %jump up in columns
         current_pos=[line, column];   %position of beta

      end
      
    
      test= (val_max==inter.T(i(v),j(v)));  %test if val_max=beta
      
      if test==0
         'pb dans ce pg modify_pot'
         val_calculee=val_max
         val_reelle=inter.T(i(v),j(v))
         
      end
      
      newpot.T(pos_max(1), pos_max(2))=alpha; % modification of beta by alpha
end

newpot.T = squeeze(newpot.T);

newpot.T = myreshape(newpot.T, newpot.sizes);


