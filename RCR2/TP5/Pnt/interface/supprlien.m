global mat nbn dag
if nbn>1

    
%names=[];

%for i=1:nbn
%    names=[names mat{i}.name];
%end  
   
names='';

for i=1:nbn
   names{i}= mat{i}.name;
end

[pere,ok]=listdlg('ListString',names,'Name','Selection of the parent..','SelectionMode','single');
if ok
   j=1;
   for i=1:nbn
      if (dag(pere,i)&(i~=pere))
         cible{j}=mat{i}.name;
         j=j+1;
      end
   end
   if j>1
      [fils,ok1]=listdlg('ListString',cible,'Name','Selection of the child..','SelectionMode','single');
      if ok1
         dag(pere,existe(cible{fils}))=0;
         raffraichir;
      end
   else
      errordlg('You have selected a leaf !!');
   end
end
end
