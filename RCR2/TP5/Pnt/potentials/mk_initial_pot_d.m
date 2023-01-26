function pot = mk_initial_pot_d(dom, ns, onodes)


if nargin<3

pot = dpot(dom, ns(dom));

else
   
ns(onodes) = 1;
pot = dpot(dom, ns(dom));

end

