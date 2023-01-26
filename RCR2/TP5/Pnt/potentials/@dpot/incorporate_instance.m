function  [pot_cl]=incorporate_instance(pot_cl,var_interest,instance,ns)

pot_var=zeros(1,ns(var_interest));

pot_var(instance)=1;

p_inter = dpot(pot_cl.domain, ns(pot_cl.domain)); %pour fixer domain et sizes
  
p_inter.T = extend_domain_table(pot_var, var_interest, ns(var_interest), p_inter.domain, p_inter.sizes);

pot_cl.T = min(pot_cl.T, p_inter.T);

