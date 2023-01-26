function [scale, scale_cl]=define_scale(clpot,nodes, potcl)

scale=[];
scale_cl=[];
         
for nn=1:length(nodes)
    for ll=1:prod(clpot{nodes(nn)}.sizes)
       if ~ismember(clpot{nodes(nn)}.T(ll), scale)
       scale=[scale,clpot{nodes(nn)}.T(ll)];
       end
    end
end

scale=sort(scale);
    
for i=1:prod(potcl.sizes)
       if ~ismember(potcl.T(i), scale_cl)
       scale_cl=[scale_cl,potcl.T(i)];
       end
end

scale_cl=sort(scale_cl);




    
    
