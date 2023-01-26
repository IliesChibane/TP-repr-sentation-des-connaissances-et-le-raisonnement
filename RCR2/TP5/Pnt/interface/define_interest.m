global  interest 

if nbn==0 %1
       errordlg('You shoud first specify the DAG structure');
else
if length(node_sizes)~=nbn %2
    errordlg('You shoud first quantify the network');
else
    
interest = cell(1,nbn);
mat_var_interest=[];

%----------------------------------------------choice of the variable of interest

if isempty(find(~isemptycell(evidence))) 
   mat_var_interest=mat;
else
    
mat_var_interest=[];

a=find(isemptycell(evidence));
j=1;
for i=a
    mat_var_interest{j}=mat{i};
    j=j+1;
end

end

for i=1:length(mat_var_interest)
col_tex = [1 1 1];
x=hand{mat_var_interest{i}.place}.rec;
set(x,'color', 1-col_tex); drawnow;
y=hand{mat_var_interest{i}.place}.tex;
set(y,'facecolor', col_tex); drawnow;
end

%mat_var_interest=[mat_evidence(1:list_evidence-1),mat_evidence(list_evidence+1:nbn)];
question=sprintf('Select variable(s) of interest : ');
titre='Variable(s) of interest';
%names=[];
%for i=1:length(mat_var_interest)
%    names=[names mat_var_interest{i}.name];
%end  
%[list_var_interest,ok3]=listdlg('ListString',names','Name',titre,'PromptString',question, 'ListSize', [260 150]);

names='';
for i=1:length(mat_var_interest)
    names{i}= mat_var_interest{i}.name;
end
[list_var_interest,ok3]=listdlg('ListString',names,'Name',titre,'PromptString',question, 'ListSize', [260 150]);

%----------------------------------------------choice of the instances of interest

if ~isempty(list_var_interest) %3

for i=1:length(list_var_interest)

%var_interest(i)=mat_var_interest{list_var_interest(i)}.place;

x=mat_var_interest{list_var_interest(i)}.name;

question=sprintf('Select the instance of interest of, %s : ',x);
titre='Instance of interest';
z=[];
for j=1:node_sizes(list_var_interest(i))
    t=strcat(lower(x), '_', num2str(j));
    z{j}=t;
end

list_instance_interest=[];
    
while isempty(list_instance_interest) %we should choose an instance
    
[list_instance_interest,ok4]=listdlg('ListString',z,'SelectionMode','single','Name',titre,'PromptString',question, 'ListSize', [260 150]);

end

interest{mat_var_interest{list_var_interest(i)}.place}=list_instance_interest;

col_tex_interest = [1 0 0];
xx=hand{mat_var_interest{list_var_interest(i)}.place}.rec;
set(xx,'color', 1-col_tex_interest); drawnow;
yy=hand{mat_var_interest{list_var_interest(i)}.place}.tex;
set(yy,'facecolor', col_tex_interest); drawnow;

end
end
end
end

