function [potcl, modif_pot,cap_max]=newpot_n_nodes(potcl,clpot, nodes,ns);

%'This procedure ensures the stability of potcl w.r.t the set nodes'

save_pot=potcl.T;
modif_pot=0;
cap_max=0;

%----------------------------computing big_domain---------------------------
 
big_domain=[];

for i=1:length(nodes)
   
   big_domain=  myunion(big_domain, clpot{nodes(i)}.domain);
   
end
if prod(ns(big_domain)) > 7000000
         
    cap_max=1;
    
else    

%-----------------------------computing the joint distribution of the nodes in nodes------------

p_inter=[];

p_inter = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes

potential=p_inter;
   
for i=1:length(nodes)
  
  p_inter.T = extend_domain_table(clpot{nodes(i)}.T, clpot{nodes(i)}.domain, clpot{nodes(i)}.sizes, p_inter.domain, p_inter.sizes);
   
  potential.T=min(potential.T, p_inter.T);
   
end

%----------------------------computing onto---------------------------

onto=[];

for i=1:length(nodes)
   
   onto=  myunion(onto, intersect(potcl.domain, clpot{nodes(i)}.domain));
   
end

%-----------------------------marginalize potential on onto-----------

inter=marginalize_pot(potential, onto);  

%-----------------------------updating potcl-------------------------

potcl=minimize_by_pot(potcl, inter);

%-----------------------------test if there is a modification---------
  
modif_pot=0;
  
if ~isequal(save_pot, potcl.T)
     modif_pot=1;
end;
  

end