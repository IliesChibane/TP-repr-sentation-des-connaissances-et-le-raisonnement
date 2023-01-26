function [m] = def_mat(in)


%in c'est la taille des domaines

m=[];
   
   
card= prod(in);

for i=1:length(in)
   
   
decalage=1;

for j=1:i-1
   decalage=decalage*in(j);
end
   
for v=1:in(i)   
   
line=(decalage*(v-1))+1;
instance=v;
     

while line<= card
        
     sauv_position=line;
     
     for l=1:decalage
        m(line,i)=instance;
        line=line+1;
     end

     line=  sauv_position +(decalage*in(i));
end

end

end



