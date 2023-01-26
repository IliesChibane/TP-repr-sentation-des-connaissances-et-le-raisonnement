  function [potcl, modif]=fast_newpot_two_neighbors(potcl,first_neighbor,second_neighbor,ns);

  
  %cette procedure n'est pas generale je l'ai remplacé par newpot_n_neighbors
 
  sauv=potcl.T;
  
  big_domain=myunion(first_neighbor.domain, second_neighbor.domain);
  
  p_inter1 = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes
  
  p_inter1.T = extend_domain_table(first_neighbor.T, first_neighbor.domain, first_neighbor.sizes, p_inter1.domain, p_inter1.sizes);

  p_inter2 = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes
  
  p_inter2.T = extend_domain_table(second_neighbor.T, second_neighbor.domain, second_neighbor.sizes, p_inter2.domain, p_inter2.sizes);
  
  p_inter1.T = min(p_inter1.T, p_inter2.T);
  
  onto=  myunion(intersect(potcl.domain, first_neighbor.domain), intersect(potcl.domain,second_neighbor.domain));
  
  inter=marginalize_pot(p_inter1, onto);   
  
  potcl=minimize_by_pot(potcl, inter);
  
  modif=0;
  
 if ~isequal(sauv, potcl.T)
     modif=1;
  end;
  
  
