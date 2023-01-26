  function [potcl, modif]=compute_new_potential(potcl,pot_parents,ns);
  
 
  %potcl:
  %potparents:
  %ns:
  
  sauv=potcl.T;

  pi_new = dpot(potcl.domain, ns(potcl.domain)); %pour fixer domain et sizes
  
  pi_new.T = extend_domain_table(pot_parents.T, pot_parents.domain, pot_parents.sizes, pi_new.domain, pi_new.sizes); %extension de pot_parents à la taille du cluster parent

  potcl.T = min(potcl.T, pi_new.T);
  
  modif=0;
  
 if ~isequal(sauv, potcl.T)
     modif=1;  % pocl.T has been changed
  end;
  
  

