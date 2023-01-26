function p = approxeq(a, b, tol)
% APPROXEQ Are a and b approximately equal (to within a specified tolerance)?
% p = approxeq(a, b, thresh)
% 'tol' defaults to 1e-3.

if nargin<3, tol = 1e-3; end

p = ~(any(abs(a(:)-b(:)) > tol));
