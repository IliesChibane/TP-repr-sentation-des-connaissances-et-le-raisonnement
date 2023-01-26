function nodes=define_nodes(adj_mat, engine, i, nodes_type, C)

   
   ps=parents(adj_mat,i);
   cs=children(adj_mat,i);
   
   switch nodes_type
      
   case 'parents',
      nodes=ps;
   case 'children',
      nodes=cs;
   case 'parents_children',
      nodes=myunion(ps,cs);
   case 'neighbors',
      nodes=[];
   		for j=1:C
            if j~=i
             if  ~isempty(intersect(engine.clusters{i}, engine.clusters{j}))
               nodes=myunion(nodes,j); 
             end
            end
        end
     end %switch
