function T = prod_CPD_and_mu_msgs(CPD, n, ps, msgs, ns, except)

% PROD_CPD_AND_PI_MSGS Multiply the CPD and all the pi messages from parents, perhaps excepting one
% T = prod_CPD_and_pi_msgs(CPD, n, ps, msgs, except)

if nargin < 6, except = -1; end

dom = [ps n];
T = dpot(dom, ns(dom), CPD.CPT);
for i=1:length(ps)
  p = ps(i);
  if p ~= except
    T = multiply_by_pot(T, dpot(p, ns(p), msgs{n}.mu_from_parent{i}));
  end
end         
