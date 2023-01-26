function small_instance= extract_onto(potcl,onto, domain,instances,option);

if nargin==5
   
equiv_pos_dom_onto=find_equiv_posns(onto, domain);

position_small_instance=1;

small_instance=[];

for i=1:length(instances)

        j=1;
        my_test=0;
        while j<=length(small_instance) & my_test==0
            if isequal(small_instance{j}.val,instances{i}.val(equiv_pos_dom_onto))
                my_test=1;
            end
            j=j+1;
        end
           
        if my_test==0        
                
        small_instance{position_small_instance}.val=instances{i}.val(equiv_pos_dom_onto);
        
        small_instance{position_small_instance}.pos=instances{i}.pos;
            
        position_small_instance=position_small_instance+1;
        
        end
        
end

else %nargin

equiv_pos_dom_onto=find_equiv_posns(onto, domain);

position_small_instance=1;

small_instance=[];

for i=1:length(instances)

        if length(find(instances{i}))==length(instances{i}) %instance complete
            
        j=1;
        my_test=0;
        while j<=length(small_instance) & my_test==0
            if isequal(small_instance{j},instances{i}(equiv_pos_dom_onto))
                my_test=1;
            end
            j=j+1;
        end
        
        if my_test==0  
        
                    small_instance{position_small_instance}=instances{i}(equiv_pos_dom_onto);
        
                    position_small_instance=position_small_instance+1;
         end
        
         end
    
      end
      
      end