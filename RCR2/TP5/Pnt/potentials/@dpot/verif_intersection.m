function [inter_neighbors, val_intersect]=verif_intersection(clpot1,clpot2);


inter_neighbors=0;
val_intersect=[];

if ~isempty (intersect(clpot1.domain, clpot2.domain))
    
    inter_neighbors=1;
    val_intersect=intersect(clpot1.domain, clpot2.domain);
    
end

