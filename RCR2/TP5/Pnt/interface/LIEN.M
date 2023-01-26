global mat nbn dag
if nbn>1
%names=[];
%for i=1:nbn
%   names=[names mat{i}.name];
%end

names='';
for i=1:nbn
    names{i}= mat{i}.name;
end

[pere,ok]=listdlg('ListString',names,'Name','Selection of the parent..','SelectionMode','single');

if ok
    names='';
    places='';
    
    j=1;
    for i=1:nbn
        if i~=pere
        names{j}= mat{i}.name;
        places{j}= mat{i}.place;
        j=j+1;
        end
    end
    
   [fils,ok1]=listdlg('ListString',names,'Name','Selection of the child..','SelectionMode','single');
   %while (ok1) & ((fils==pere)|(dag(fils,pere)==1))
   %   [fils,ok1]=listdlg('ListString',names','Name','Selection of the child..','SelectionMode','single');
   %end
   
   if ok1
      %dag(pere,fils)=1;
      dag(pere,places{fils})=1;
      raffraichir;
   end
end
end



   