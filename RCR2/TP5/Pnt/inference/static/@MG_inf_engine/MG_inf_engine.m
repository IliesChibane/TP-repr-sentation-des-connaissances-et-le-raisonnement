function engine = MG_inf_engine(pnet)
% MG_INF_ENGINE Junction tree inference engine
% engine = MG_inf_engine(pnet, obs_nodes, clusters, stages, onepass)
%

% Mathworks says you have to put all this crap up front when defining a constructor...
if nargin==0
  engine.dummy = [];
  engine = class(engine, 'MG_inf_engine');
  disp('MG inf engine no args');
  return;
elseif isa(pnet, 'MG_inf_engine')
  engine = pnet;
  disp('MG inf engine self arg');
  return;
end

N = length(pnet.dag);

% I: BUILDING Moral Graph

[engine.clusters] = dag_to_clusters(pnet);

engine.clq_ass_to_node = zeros(1, N);

num_clusters = length(engine.clusters);

% each node has its corresponding cluster

for i=1:N
engine.clq_ass_to_node(i) = i; 
end

% Compute the separators between connected clusters. 
% rq: les separateurs sont corrects mais ne verifie pas jtree  property

engine.separators = cell(num_clusters, num_clusters);

for i=1:num_clusters
   for j=(i+1):num_clusters
   engine.separators{i,j} =  intersect(engine.clusters{i}, engine.clusters{j});
end
end

C = length(engine.clusters);
engine.clpot = cell(1,C);
engine.seppot = cell(C,C);

engine = class(engine, 'MG_inf_engine', inf_engine(pnet));





