%------------------------------------the network is empty--------------------------------------------------

if nbn==0 %1
       errordlg('You shoud first specify the DAG structure');
else
    
connected=check_connected(dag,nbn);

%------------------------------------The network is disconnected-------------------------

if connected==0 %2
    
    errordlg('The DAG is disconnected');
    
else

%------------------------------------The network is not quantified in its totality-------------------------

if length(node_sizes)~=nbn %3
    errordlg('You shoud first quantify the network');
else
    
%---------------------------------------------------------No evidence----------------------------------------

if isempty(find(~isemptycell(evidence))) %4
errordlg('No evidence defined');

else
    
%------------------------------------------------------The evidence is defined ------------------------------
 
engine = prod_Pearl_inf_engine(pnet);

if ~isempty(engine) %5
    
[engine] = global_propagation(engine, evidence)

e=' ';
    for i=1:length(evidence)
    if ~isempty(evidence{i})
    w=mat{i}.name;
    v=strcat(lower(w), '_', num2str(evidence{i}));
    e=strcat(e, ' ', v);
    end
    end
    
e=[' ' e];


%------------------------------------------------------The variable of interest is defined-------------------

if ~isempty(find(~isemptycell(interest))) %6
    
%------------------------------------------------------The instance of interest is defined-------------------
    
for i=1:length(interest)
    
if ~isempty(interest{i})
    
marg = marginal_nodes(engine, i);

BEL_Cdt_classique=marg.T(interest{i})

x=[' ' mat{i}.name];

y=[' ' num2str(BEL_Cdt_classique)];

uiwait(msgbox(strcat('The possibility degree of ', lower(x), '_',  num2str(interest{i}), ' in context of ', e, ' is ', y), 'Result'));

end
end


else

%------------------------------------------------------No variable of interest----------------------------
       
%mat_var_interest=[];  %variables not implied in evidence
%j=1;
%for i=1:length(mat)
 %   if ~ismember(mat{i}.place,list_evidence)
  %      mat_var_interest{j}=mat{i};
   %     j=j+1;
   %end
   %end

for i=1:nbn %compute the possibility distribution of each node in mat_var_interest
         
   
         if isempty(evidence{i}) %i is not in evidence i.e. it is a var of interest

         marg = marginal_nodes(engine, i);
         BEL_Cdt_classique=marg.T;
                  
         x=[' ' mat{i}.name];
         
         y=num2str(BEL_Cdt_classique);
         
         %y(:,2)=y;
         
         %y(:,1)=[' '];
         
         z='';
         for j=1:length(BEL_Cdt_classique)
             z{j}=strcat(lower(x), '_', num2str(j));
         end
         
         uiwait(msgbox(strcat('The possibility distribution of ', z',  ' in context of ', e, ' is ', y), 'Result'));
  
         end

end

%---------------------------------------------------------------------------------------------------------
end             %5    
end %4
end %3
end %2
end %1
end



