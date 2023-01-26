function T = min_CPD_and_mu_msgs(CPD, n, ps, msgs, ns, except)
% MIN_CPD_AND_mu_MSGS Minimize the CPD and all the mu messages from parents, perhaps excepting one
% T = min_CPD_and_mu_msgs(CPD, n, ps, msgs, except)


if nargin < 6, except = -1; end
dom = [ps n];
%%%%ns = sparse(1, max(dom));
%ns = zeros(1, max(dom))
%ns(dom) = mysize(CPD.CPT)

T = dpot(dom, ns(dom), CPD.CPT);
for i=1:length(ps)
   p = ps(i);
  if p ~= except
    T = minimize_by_pot(T, dpot(p, ns(p), msgs{n}.mu_from_parent{i}));
  end
end     


