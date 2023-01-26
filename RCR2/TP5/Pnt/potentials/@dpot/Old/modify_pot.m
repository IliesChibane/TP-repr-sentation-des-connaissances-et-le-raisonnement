function clpot=modify_pot(clpot, ps, alpha,ns);
'je suis ds modify'
valalpha_stable=alpha

dom = ns(clpot.domain)';
dom_onto=ns(ps)';
ndx = find_equiv_posns(ps, clpot.domain);

inter=marginalize_pot(clpot, ps); %inter contains the potential relative to ps

inconsistent_index=find(inter.T~=alpha)';

for i=1:length(inconsistent_index)
   [index_vector] = def_marg(dom,dom_onto, ndx, inconsistent_index(i));
   
   cpt=1;
   
   current_position=index_vector(cpt);
   
   test=0;

while test==0
   if  clpot.T(current_position)==inter.T(inconsistent_index(i))
          clpot.T(current_position)=alpha;
          test=1;
   end          
   
   if test==0
       cpt=cpt+1;
       current_position=  index_vector(cpt);
    end
 end
    
    
end

