function T = prod_CPD_and_pi_msgs_fast(CPD, n, ps, msgs, except, ndx)

dom = [ps n];
%ns = sparse(1, max(dom));
ns = zeros(1, max(dom));
ns(dom) = mysize(CPD.CPT);
temp = CPD.CPT;
for i=1:length(ps)
  p = ps(i);
  if p ~= except
    %T = multiply_by_pot(T, dpot(p, ns(p), msgs{n}.pi_from_parent{i}));
    pi = msgs{n}.pi_from_parent{i};
    temp = temp .* pi(ndx{n,i});
  end
end         
T = dpot(dom, ns(dom), temp);
