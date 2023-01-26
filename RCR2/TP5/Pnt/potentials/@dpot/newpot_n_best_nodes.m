function [potcl, modif_pot, cap_max]=newpot_n_best_nodes(potcl,clpot, nodes,ns);

%This procedure updates the potential of a cluster potcl} using the best instances in
%the cartesian product relative to its nodes (i.e. nodes}).

%The main stenodes of this procedure are:

%1- computing the best instances in each parent (i.e. sauv_max_index) and the order in which we should cover them (i.e. pos) using extract_best_instances},

%2- computing of the domain of the nodes (i.e. big_domain),

%3- computing the best instances in the cartesian product of the nodes (i.e. best_nodes_instances) using compute_best_nodes_instances,

%4- computing the domain of the separators between the treated cluster and the nodes (i.e onto}),

%5- computing the best instances relative to onto from best_nodes_instances (i.e sep_instances_from_nodes) using extract_onto,

%6- computing the best instances in the treated cluster potcl (i.e. best_cl_instances) using extract_best_instances,

%7- computing the best instances relative to onto} from best_cl_instances (i.e sep_instances_from_cl) using extract_onto,

%8- testing coherence between sep_instances_from_nodes and sep_instances_from_cl,

%9- if incoherence (i.e uncoherent_instances \not= \emptyset) we should modif_pot the degree of incoherent instances by choosing the next degree in scale.


%Then to construct the best elements in the cartesian product we call compute_best_nodes_instances 

modif_pot=0;  

%'--------------------------Computing the scale-------------------------------------------'

[scale, scale_cl]=define_scale(clpot,nodes,potcl); %scale possibilistic scale relative to nodes  i.e clpot and  scale_cl is relative to potcl

pos_val_in_scale=length(scale);

%'---------------------computing big_domain from nodes----------------------'

big_domain=[];

for i=1:length(nodes)
   
   big_domain=  myunion(big_domain, clpot{nodes(i)}.domain);
   
end

%'--------------------------------------------------------------------------------------'

exist_best_nodes_instances =0;

nb_modif_pot=1;

while exist_best_nodes_instances ==0  %this loop is finite since the scale is finite and we are sure to find a global instance

val_max_nodes=scale(pos_val_in_scale);

%'---------------------computing the max instances of each node----------------------'

[sauv_max_index, pos] = extract_best_instances(potcl, val_max_nodes, clpot,  nodes); %potcl reste car on utilise la meme fonction avec un seul pram plus loin

%'---------------------computing best_global_instances----------------------'

cap_max=0;

 [exist_best_nodes_instances, best_nodes_instances, cap_max] =compute_best_nodes_instances(sauv_max_index, big_domain, potcl,clpot, nodes,pos); %potcl inutile
 
 if exist_best_nodes_instances ==0
     
     pos_val_in_scale=length(scale)- nb_modif_pot;

     nb_modif_pot=nb_modif_pot+1;
     
 end
     
end %while

%'--------------------------------------------------------------------------------------'
 
if cap_max==0
    
val_max_cluster=maximum_value(potcl); 

if val_max_nodes ~= val_max_cluster  %in this case we are sure that we should modif_pot the best instances 
    
    incoherent_instances = find(potcl.T==val_max_cluster);
    
    potcl.T(incoherent_instances)=val_max_nodes;

    modif_pot=1;
    
else
%'---------------------computing onto--------------------'

onto=[];

for i=1:length(nodes)
   
   onto=  myunion(onto, intersect(potcl.domain, clpot{nodes(i)}.domain));
   
end

%'-------------------Extract dom from best_nodes_instances------------'

sep_instances_from_nodes = extract_onto(potcl,onto, big_domain, best_nodes_instances); %potcl inutile

%'-------------------------affichage--------------------'

  %big_d=big_domain
  %for i=1:length(best_nodes_instances)
  %    big=best_nodes_instances{i}
  %end 

  %on=onto
  
  %for i=1:length(sep_instances_from_nodes)
  %    small=sep_instances_from_nodes{i}
  %end

%'----------------------index of val max in potcl---------------'

[best_cl_instances] = extract_best_instances(potcl,val_max_cluster);

%'-------------------Extract dom from potcl-------------------------'

sep_instances_from_cl = extract_onto(potcl,onto,potcl.domain,  best_cl_instances, 'val+pos'); %potcl inutile

%'-----------------------Affichage-------------------------'

%for i=1:length(sep_instances_from_nodes)
%      small_big=sep_instances_from_nodes{i}
%  end

% for i=1:length(sep_instances_from_cl )
%      small_cl=sep_instances_from_cl {i}
%  end
 
 %'-----------------------test-------------------------'

pos_incoherent_instance=1;
incoherent_instances=[];
for i=1:length(sep_instances_from_cl )
    j=1;
    my_test=0;
    while j<=length(sep_instances_from_nodes) & my_test==0
       
        if  isequal(sep_instances_from_nodes{j},sep_instances_from_cl {i}.val) %existe 
           my_test=1;
        end
        j=j+1;
    end
    
    if my_test==0
        incoherent_instances(pos_incoherent_instance)=sep_instances_from_cl{i}.pos;
        pos_incoherent_instance=pos_incoherent_instance+1;
    end

end

if ~isempty(incoherent_instances)
    
    
    x=find(scale==val_max_nodes);
    
    if x~=1 

    potcl.T(incoherent_instances)=scale(x-1);

    modif_pot=1;
    
    else
 
        
   cap_max=1; %il faut verifier ce qu'il faut mettre

    
   end

end

end % if val_max_nodes ~= val_max_cluster

end %cap_max


    
