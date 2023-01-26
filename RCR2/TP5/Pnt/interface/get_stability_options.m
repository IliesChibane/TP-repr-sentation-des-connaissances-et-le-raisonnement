global nb_nodes nodes_type 

x = get(hh1,'Value');

if x==3
    nb_nodes='n_best';
else
    if x==2
    nb_nodes='n';
end
end    

if x==1
    nb_nodes=x;
    
    nodes_type ='neighbors';
    
    
else

y = get(hhh1,'Value');

switch y
   case 1,
      nodes_type ='parents';
   case 2,
      nodes_type ='children';
   case 3,
      nodes_type ='parents_children';
   case 4,
      nodes_type ='neighbors'
end %switch

end

close

Anytime_propagation;

