global pnet node_sizes


connected=check_connected(dag,nbn);

if connected==1

define_order;

%--------------------------------------define cardinalities--------------------------------
node_sizes=[];

for i = 1:nbn
   reponse=0;
   while reponse <= 0
          def={'0'};
          x=mat{i}.name;
          question= sprintf('Give the cardinality of the variable %s : ',x);
          reponse=inputdlg(question,titre,1,def,AddOpts);
          reponse=str2num(reponse{1});
   end
      node_sizes(i)=reponse;
end

pnet = mk_pnet(dag, node_sizes, nodes);
   
%--------------------------------------define distributions--------------------------------

for i=1:nbn %1
    
    %normalement mat{i}.place=i
    
    ps=parents(dag,mat{i}.place);
    
    prompt=[];
    def=[];
    lineNo=1;
    addopts.Resize='on';
    addopts.WindowStyle='normal';
    addopts.Interpreter='none';

    name_var=[' ' mat{i}.name];

    
    if ~isempty(ps) %2
    
    parent_order=[];
    for j=1:length(ps) %3
        k=1;
        test_trouve=0;
        while k <=  length(order) & test_trouve==0
            if order(k).place==ps(j)
                parent_order=[parent_order order(k).place];
                test_trouve=1;
            end
            k=k+1;
        end
    end %3
    
    %parent_order contient l'ordre des parents % rapport à tous les noeuds
    
    [v,p]=sort(parent_order);

    final_parent_order=[]; %final_parent_order  contient l'ordre des parents % à eux
   
    for l=1:length(ps)
        final_parent_order=[final_parent_order ps(p(l))];
    end
    
    parent_names=[' '];
    for l=1:length(final_parent_order)
        parent_names=[parent_names mat{final_parent_order(l)}.name];
    end
        
     Cart=prod(node_sizes(ps));   
     
     mat_index=[final_parent_order mat{i}.place];
     
     mat_names=def_mat(node_sizes(mat_index));

    for k=1:node_sizes(mat{i}.place)*Cart
      instance= mat_names(k,:);
      
      parent_instances=' ';

      for m=1:length(ps)
          parent_instances=strcat(parent_instances, parent_names(m+1), '_', num2str(instance(m)));
      end
          
      new_instance=strcat(name_var, '_', num2str(instance(length(instance))), '|', parent_instances);
      chaine=strcat('Give the possibility degree of ', new_instance);
      prompt{k}=chaine;
      def{k}='1';
    end
    

dlgTitle=strcat('Conditional distribution of ',  name_var, ' in the context of ', ' ', parent_names);
rep=inputdlg(prompt,dlgTitle,lineNo,def,addopts);



  
else
    for k=1:node_sizes(mat{i}.place)
      chaine=strcat('Give the possibility degree of ',mat{i}.name,'_',num2str(k));
      prompt{k}=chaine;
      def{k}='1';
    end
  

dlgTitle=strcat('A priori distribution ',  name_var);
rep=inputdlg(prompt,dlgTitle,lineNo,def,addopts)   

end

distribution=[];
for n=1:length(rep)
    distribution =[distribution str2num(rep{n})];
end


pnet.CPD{mat{i}.place} = tabular_CPD(pnet, mat{i}.place, distribution);

end

else
    
          errordlg('The dag is disconnected');
end

    
   

