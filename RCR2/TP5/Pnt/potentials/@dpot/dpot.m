function pot = dpot(domain, sizes, T)
% pot = dpot(domain, sizes, T)
%
% sizes(i) is the size of the i'th domain element.
% T defaults to all 1s.

%assert(length(sizes) == length(domain));


pot.domain = domain;
if nargin < 3
  pot.T = myones(sizes);
else
  %pot.T = T;
  pot.T = myreshape(T, sizes);
  %assert(prod(sizes)==prod(size(T)));
end
pot.sizes = sizes(:)';
pot = class(pot, 'dpot');

