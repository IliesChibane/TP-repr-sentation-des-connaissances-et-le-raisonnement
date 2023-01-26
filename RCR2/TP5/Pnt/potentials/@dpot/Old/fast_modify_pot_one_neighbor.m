function clpot=fast_modify_pot_one_neighbor(clpot, ps, alpha,ns);

%ancienne lorsque je faisais la consistance à un neighbor

dom = clpot.domain;
ndx = find_equiv_posns(ps, dom);
nb_instance=ns(ps);

decalage=1;
for i=1:ndx-1
   decalage=decalage*ns(dom(i));
end

inter=marginalize_pot(clpot, ps); %inter contains the potential relative to ps

inconsistent_index=find(inter.T~=alpha);

nb_inconsistent_instances= length(inconsistent_index);

for i=1:nb_inconsistent_instances
   first_position=(decalage*(inconsistent_index(i)-1))+1;  
   current_position=first_position;
   test=0;
   while test==0
   sauv_position=current_position;
   for l=1:decalage
      if  clpot.T(current_position)==inter.T(inconsistent_index(i))
          clpot.T(current_position)=alpha;
          test=1;
       end          
       current_position=current_position+1;
   end
   current_position=  sauv_position +(decalage*nb_instance);
end

end


