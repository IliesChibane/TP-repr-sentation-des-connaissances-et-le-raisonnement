global  evidence interest

if nbn==0 %1
       errordlg('You shoud first specify the DAG structure');
else
if length(node_sizes)~=nbn %2
    errordlg('You shoud first quantify the network');
else
    
evidence = cell(1,nbn);
interest = cell(1,nbn);

    
for i=1:nbn
col_tex = [1 1 1];
x=hand{i}.rec;
set(x,'color', 1-col_tex); drawnow;
y=hand{i}.tex;
set(y,'facecolor', col_tex); drawnow;
end

end
end