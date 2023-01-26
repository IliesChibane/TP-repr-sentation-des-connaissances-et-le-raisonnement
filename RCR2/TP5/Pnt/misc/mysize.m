function sz = mysize(M)
% MYSIZE Like the built-in size, except it returns n if M is a vector of length n, and 1 if M is a scalar.
% sz = mysize(M)
% 
% size would return [1 n] or [n 1] for a vector, and [1 1] for a scalar.

if isvector(M)
  sz = length(M);
else
  sz = size(M);
end
