 function  p_inter= add_parents_to_cluster(oldcl,added,ns)
 
 added=union(oldcl.domain,added);
  
 p_inter = dpot(added, ns(added)); %pour fixer domain et sizes
 
 taille=p_inter.sizes
 
 p_inter.T = extend_domain_table(oldcl.T, oldcl.domain, oldcl.sizes, p_inter.domain, p_inter.sizes);
 
 
 
 %p_inter.T = extend_domain_table(oldcl.T, oldcl.domain, oldcl.sizes, added, ns(added)');
 
 %p_inter.domain=added;
 
 %p_inter.sizes=ns(added)';
 
 %p_inter = class(p_inter, 'dpot');

