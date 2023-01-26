function [engine,clpot,global_consistency, alpha_consistency,cap_max]=check_consistency_gl_instances(engine,  clpot, alpha_stable, C);

%consistency\_by\_computing\_global\_instances ds le rapport

    %computes the best elements in the whole cartesian product
    %if We find a global instance ok : we are consistenct
    %else :decrease the best instnace in the blocked cluster w.r.t to the treated scale and restabilize

%'----------------------------------------------------------------------------------------------------------------------------'

exist_global_instance=0;
val_max=alpha_stable;

  
   [exist_global_instance,scale, sauv_index_clusters,cap_max]=compute_best_global_instances(clpot{1},val_max,clpot,C);
   %clpot{1} est inutile
   
  if cap_max==0
   
   if exist_global_instance==0  % decrease in scale
          
        x=find(scale==val_max);
    
        if x~=1 
        val_max=scale(x-1);
        end

      for i=1:C
          
          clpot{i}=decrease_in_scale(val_max, clpot{i},sauv_index_clusters{i});

      end
        
      global_consistency=0;
  else
      global_consistency=1;
      
   end 

   end %cap_max

  

alpha_consistency=maximum_value(clpot{1},C);


