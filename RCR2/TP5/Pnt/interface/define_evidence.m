global  evidence 

if nbn==0 %1
       errordlg('You shoud first specify the DAG structure');
else
if length(node_sizes)~=nbn %2
    errordlg('You shoud first quantify the network');
else
    
evidence = cell(1,nbn);
mat_evidence=[];

%----------------------------------------------choice of the evidence variables

if isempty(find(~isemptycell(interest)))  
   mat_evidence=mat;
else
    
   
a=find(isemptycell(interest));
j=1;
for i=a
    mat_evidence{j}=mat{i};
    j=j+1;
end
end
    
for i=1:length(mat_evidence)
col_tex = [1 1 1];
x=hand{mat_evidence{i}.place}.rec;
set(x,'color', 1-col_tex); drawnow;
y=hand{mat_evidence{i}.place}.tex;
set(y,'facecolor', col_tex); drawnow;
end


question=sprintf('Select the observed node(s) : ');
titre='Evidence';

%names=[];
%for i=1:length(mat_evidence)
%    names=[names mat_evidence{i}.name];
%end  
%[list_evidence,ok1]=listdlg('ListString',names','Name',titre,'PromptString',question, 'ListSize', [260 150]);

names='';
for i=1:length(mat_evidence)
    names{i}= mat_evidence{i}.name;
end

[list_evidence,ok1]=listdlg('ListString',names,'Name',titre,'PromptString',question, 'ListSize', [260 150]);

if ~isempty(list_evidence)%3

%----------------------------------------------choice of the instances of evidence
for i=1:length(list_evidence) %4

x=mat_evidence{list_evidence(i)}.name;

question=sprintf('Select the instance of the observed variable, %s : ',x);
titre='Evidence';
z=[];
for j=1:node_sizes(list_evidence(i))
    t=strcat(lower(x), '_', num2str(j));
    z{j}=t;
end

list_instance_evidence=[];
    
while isempty(list_instance_evidence) %we should choose an instance
    
[list_instance_evidence,ok2]=listdlg('ListString',z,'SelectionMode','single','Name',titre,'PromptString',question, 'ListSize', [260 150]);

end

evidence{mat_evidence{list_evidence(i)}.place}=list_instance_evidence;

col_tex = [0 0 1];
xx=hand{mat_evidence{list_evidence(i)}.place}.rec;
set(xx,'color', 1-col_tex); drawnow;
yy=hand{mat_evidence{list_evidence(i)}.place}.tex;
set(yy,'facecolor', col_tex); drawnow;

end %3
end
end
end

