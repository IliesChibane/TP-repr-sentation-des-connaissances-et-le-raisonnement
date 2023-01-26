function T = mk_stochastic(T)
% MK_STOCHASTIC Ensure the argument is a stochastic matrix, i.e., the sum over the last dimension is 1.
% T = mk_stochastic(T)
%
% If T is a vector, it will sum to 1.
% If T is a matrix, each row will sum to 1.
% If T is a 3D array, then sum_k T(i,j,k) = 1 for all i,j.

if isvector(T)
  T = normalise(T);
else
  n = ndims(T);
  % Copy the normaliser plane for each i.
  normaliser = sum(T, n);
  normaliser = repmat(normaliser, [ones(1,n-1) size(T,n)]);
  % Set zeros to 1 before dividing
  % This is valid since normaliser(i) = 0 iff T(i) = 0
  normaliser = normaliser + (normaliser==0);
  T = T ./ normaliser;
end
