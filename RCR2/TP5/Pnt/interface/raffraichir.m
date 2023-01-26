global dag nbn
h=findobj('Tag','Arrow');
delete(h);
for i=1:nbn
  for j=1:nbn
      if ((dag(i,j)) & (i~=j))
         fleche(i,j);
      end
   end
end


