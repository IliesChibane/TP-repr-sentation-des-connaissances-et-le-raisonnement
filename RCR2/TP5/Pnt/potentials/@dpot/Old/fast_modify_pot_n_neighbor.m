function clpot=fast_modify_pot_n_neighbor(clpot, ps, alpha,ns);

%Searching the position of $\beta$ in oldpot so that to replace it by $\alpha$. 
%To do so, we compute the distribution of parents and we search the position of the values
%inferior to $\alpha$ and we place them in i and j which are vectors containing row and column indices, respectively. 
%For instance if i=[1 2 1] j=[1 1 2] then the instances 11, 21, 12 of parents are inconsistent. 

%Then, in order to search beta (to replace it by alpha) for the instance 21 of parents, we start in
%oldpot at position [line, column]=[2, 1] and we look for the
%maximum value for this instance in oldpot (i.e inter.T(inconsistent_index(i)). The maximization is
%always performed in the same line (i.e 2). Indeed, we maximize on
%the child which is always in the last position (due to the
%topological order) but we should jump up in columns by the
%possible configurations of parents in the same line (i.e
%column_parents).


dom = clpot.domain;
ndx = find_equiv_posns(ps, dom);

decalage=1;
for i=1:ndx-1
   decalage=decalage*ns(dom(i));
end

inter=marginalize_pot(clpot, ps); %inter contains the potential relative to ps

inconsistent_index=find(inter.T~=alpha);

nb_inconsistent_instances= length(inconsistent_index);

for i=1:nb_inconsistent_instances
   first_position=inconsistent_index(i);  
   current_position=first_position;
   test=0;
   while test==0
       if  clpot.T(current_position)==inter.T(inconsistent_index(i))
          clpot.T(current_position)=alpha;
          test=1;
       end          
       current_position=  current_position+decalage;
    end
    if  prod(size(clpot.T))< (current_position-1)
           'pbbbbbbbbbbbbbbb ds fast_modify_pot_n_neighbor'
    end
end


