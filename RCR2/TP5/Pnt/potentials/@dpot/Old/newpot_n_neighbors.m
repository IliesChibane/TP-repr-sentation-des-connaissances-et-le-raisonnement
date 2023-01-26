function [potcl, modif_pot]=newpot_n_neighbors(potcl,clpot, neighbors,ns);

%'This procedure ensures the stability of potcl w.r.t the set neighbors'

save_pot=potcl.T;
 
big_domain=[];

for i=1:length(neighbors)
   
   big_domain=  myunion(big_domain, clpot{neighbors(i)}.domain);
   
end

p_inter = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes

%p_inter.T= extend_domain_table(clpot{neighbors(1)}.T, clpot{neighbors(1)}.domain, clpot{neighbors(1)}.sizes, p_inter.domain, p_inter.sizes);

potential=p_inter;
   
for i=1:length(neighbors)
  
  p_inter.T = extend_domain_table(clpot{neighbors(i)}.T, clpot{neighbors(i)}.domain, clpot{neighbors(i)}.sizes, p_inter.domain, p_inter.sizes);
   
  potential.T=min(potential.T, p_inter.T);
   
end


 
onto=[];

for i=1:length(neighbors)
   
   onto=  myunion(onto, intersect(potcl.domain, clpot{neighbors(i)}.domain));
   
end

inter=marginalize_pot(potential, onto);  

potcl=minimize_by_pot(potcl, inter);
  
modif_pot=0;
  
if ~isequal(save_pot, potcl.T)
     modif_pot=1;
end;
  
  
