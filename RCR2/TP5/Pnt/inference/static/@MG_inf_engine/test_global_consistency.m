function val_test=test_global_consistency(engine, pnet,  clpot, C, alpha_stable)


val_test=1;
i=C;	% we test leafs clusters first
while (i>=1) &  (val_test==1);  		 
   ps =  parents(pnet.dag,i);   
      
   if  ~isempty(ps)  % test consistency is useless for roots
   
       cl=engine.clq_ass_to_node(i); %the cluster assigned to node i
      	
       pot_parents=marginalize_pot(clpot{cl}, ps);
     	
      % je marginalize le potentiel de chaque cluster sur les parents du noeud qui lui correspond
    	% Apres, pour tester la consistance il suffit de voire s'il ya une valeur inferieure à alpha
   
  
       consistency=  check_consistency_cluster(C,pot_parents,alpha_stable);
         
      if (consistency==0) 
	        val_test=0;
      end 
      
   end 
i=i-1;   
end 
