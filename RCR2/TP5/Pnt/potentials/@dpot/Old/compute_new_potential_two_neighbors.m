  function [potcl, modif]=compute_new_potential_two_neighbors(potcl,first_parent,second_parent,ns);
  
  'ici'
  
  sauv=potcl.T;
  
  big_domain=myunion(first_parent.domain, second_parent.domain);
  
  p_inter1 = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes
  
  p_inter1.T = extend_domain_table(first_parent.T, first_parent.domain, first_parent.sizes, p_inter1.domain, p_inter1.sizes);

  p_inter2 = dpot(big_domain, ns(big_domain)); %pour fixer domain et sizes
  
  p_inter2.T = extend_domain_table(second_parent.T, second_parent.domain, second_parent.sizes, p_inter2.domain, p_inter2.sizes);
  
  p_inter1.T = min(p_inter1.T, p_inter2.T);
  
  onto=  myunion(intersect(potcl.domain, first_parent.domain, first_parent.domain);
  
  inter=marginalize_pot(p_inter1.T, onto);   
  
  potcl.T=min(potcl.T, inter);
  
  modif=0;
  
 if ~isequal(sauv, potcl.T)
     modif=1;
  end;
  
  
