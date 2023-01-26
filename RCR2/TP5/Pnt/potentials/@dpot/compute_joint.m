function    inter=compute_joint(sauvcl,potcl,ns)

d_inter=myunion(sauvcl.domain,potcl.domain);
inter=dpot(d_inter,ns(d_inter));

inter.T = extend_domain_table(sauvcl.T, sauvcl.domain, sauvcl.sizes, inter.domain, inter.sizes); %extension de pot_parents à la taille du cluster parent

sauv=inter.T;

inter.T = extend_domain_table(potcl.T, potcl.domain, potcl.sizes, inter.domain, inter.sizes); %extension de pot_parents à la taille du cluster parent


inter.T=min(inter.T, sauv);

