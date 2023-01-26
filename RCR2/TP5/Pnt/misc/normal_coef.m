function c = normal_coef (Sigma)
%
% c = normal_coef (Sigma)
% Compute the normalizing coefficient for the gaussian.

n = length(Sigma);
c = (2*pi)^(-n/2) * det(Sigma)^(-0.5);

