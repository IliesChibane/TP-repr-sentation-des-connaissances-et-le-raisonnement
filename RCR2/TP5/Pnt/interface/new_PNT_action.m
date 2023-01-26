global mat dag nbn node_sizes sauv_node_sizes order evidence  interest filename path


for i=1:length(hand)
    delete(hand{i}.rec);
    delete(hand{i}.tex);
end

h=findobj('Tag','Arrow');
delete(h);
   

nbn=0;
nodes=[];
mat=[];
dag = zeros(nbn,nbn);
node_sizes=[];
order=[];
sauv_node_sizes=[];
evidence = cell(1,nbn);
interest = cell(1,nbn);
hand=[];   
filename=0;
path=0;