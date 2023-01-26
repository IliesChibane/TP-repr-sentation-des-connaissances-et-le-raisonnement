 function  [p_inter, cap_max]= update_cluster_potential(oldcl,added,ns)
 
 cap_max=0;
 
 p_inter=[];
 
 added=union(oldcl.domain,added);
  
 size_cluster=prod(ns(added)); %me permet de voir la taille des clusters

 if size_cluster > 7000000
     
 cap_max=1;

 else
    
 p_inter = dpot(added, ns(added)); %pour fixer domain et sizes
 
 p_inter.T = extend_domain_table(oldcl.T, oldcl.domain, oldcl.sizes, p_inter.domain, p_inter.sizes);
 
 end

 
 