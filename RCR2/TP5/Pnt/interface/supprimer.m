global mat nbn nodes hand dag




if ~nbn
   errordlg('No elements to delete!');
else
%names=[];
%for i=1:nbn
%    names=[names mat{i}.name];
%end  
%[dep,ok]=listdlg('ListString',names','SelectionMode','single','Name','Delete nodes..');

names='';
for i=1:nbn
    names{i}= mat{i}.name;
end

[dep,ok]=listdlg('ListString',names,'SelectionMode','single','Name','Delete nodes..');
if ok
   %update the DAG
   delete(hand{dep}.rec);
   delete(hand{dep}.tex);
   
   
   if nbn>1
      if dep==1  %the first element in the list is selected
         for i=dep:nbn
             mat{i}.place=mat{i}.place-1;
         end 

         mat=mat(2:nbn);
         hand=hand(2:nbn);
         dag=dag(2:nbn,2:nbn);
         if ~isempty(node_sizes)
         node_sizes=node_sizes(2:nbn); 
         end
      elseif dep==nbn %the last element in the list is selected
         mat=mat(1:nbn-1);
         hand=hand(1:nbn-1);
         dag=dag(1:nbn-1,1:nbn-1);
         if ~isempty(node_sizes)
         node_sizes=node_sizes(1:nbn-1);
         end
      else %neither the first nor the last elment are selected
         for i=dep:nbn
             mat{i}.place=mat{i}.place-1;
         end
                      
         mat=[mat(1:dep-1),mat(dep+1:nbn)];
         hand=[hand(1:dep-1),hand(dep+1:nbn)];
         dag=[dag(1:dep-1,:);dag(dep+1:nbn,:)];
         dag=[dag(:,1:dep-1),dag(:,dep+1:nbn)];
         if ~isempty(node_sizes)
         node_sizes=[node_sizes(1:dep-1),node_sizes(dep+1:nbn)];
         end
      end
      nbn=nbn-1;   
      
      
      raffraichir;
   else
%      clear mat dag nbn node_sizes sauv_node_sizes order evidence  var_interest instance_interest;
      
        hand=[];
        nbn=0;
        nodes=[];
        mat=[];
        dag = zeros(nbn,nbn);
        node_sizes=[];
        order=[];
        sauv_node_sizes=[];
        evidence = cell(1,nbn);
        interest = cell(1,nbn);
        cla;
   end
end
end

nodes=1:nbn;
