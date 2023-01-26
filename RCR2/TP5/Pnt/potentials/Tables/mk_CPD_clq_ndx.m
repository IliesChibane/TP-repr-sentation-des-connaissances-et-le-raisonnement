function [clq_ass_to_node, CPD_ndx] = mk_CPD_clq_ndx(engine, ss, T)

clq_ass_to_node = zeros(ss, T);
for i=1:ss
  for t=1:T
    clq_ass_to_node(i, t) = clq_containing_nodes(engine, i + (t-1)*ss);
  end
end

CPD_ndx = cell(ss, T);
s = struct(engine); % violate object privacy
for t=1:T
  %dom = 1:ss;
  %CPD_ndx(:,t) = s.CPD_ndx(dom + (t-1)*ss);
  for i=1:ss
    CPD_ndx{i,t} = s.CPD_ndx{i + (t-1)*ss};
  end
end
