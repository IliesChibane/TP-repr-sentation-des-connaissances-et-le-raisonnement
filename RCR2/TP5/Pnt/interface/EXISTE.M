function h=existe(var)
global mat nbn 
if (nbn==0) 
   h=0;
else
   i=1;
   while (i<nbn) & (~strcmp(var,mat{i}.name))
      i=i+1;
   end
   if (strcmp(var,mat{i}.name)) 
       h=i;
   else
      h=0;
   end

end
