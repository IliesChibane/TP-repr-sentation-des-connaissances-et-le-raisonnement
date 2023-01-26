function CPD = discrete_CPD(clamped)
% DISCRETE_CPD Virtual constructor for generic discrete CPD
% CPD = discrete_CPD(clamped)

if nargin < 1, clamped = 0; end

CPD.dummy = 1;
CPD = class(CPD, 'discrete_CPD', generic_CPD(clamped));
