
function [clusters] = dag_to_clusters(pnet)

N = length(pnet.dag);

%%STEP1: Constructing the Moral Graph

%% Identifying clusters of the moral graph by adding to each node its parent set

ns=pnet.node_sizes(:);

clusters = {};

j=1;

for i=1:N
      ps = parents(pnet.dag,i);
      clusters{j} = myunion(ps, i);        % the cluster will always contain at least the node i itself
      j=j+1;
end

