function connected=check_connected(dag,nbn)

%to avoid disconnected subgraphs

marked_nodes=nbn;  %the last node
selected_node=nbn;
list_nodes=nbn;
ps=parents(dag,nbn);

for ll=1:length(ps)
    list_nodes(length(list_nodes)+1)=ps(ll);
end


while (length(marked_nodes)+1) <= length(list_nodes)
    selected_node=list_nodes(length(marked_nodes)+1);
    marked_nodes=[marked_nodes selected_node];
    ps=parents(dag,selected_node);
    cs=children(dag,selected_node);

    for ll=1:length(ps)
        if ~ismember(ps(ll),list_nodes)
           list_nodes(length(list_nodes)+1)=ps(ll);
        end
    end

    for ll=1:length(cs)
        if ~ismember(cs(ll),list_nodes)
           list_nodes(length(list_nodes)+1)=cs(ll);
        end
    end

end

connected=(length(list_nodes)==nbn);