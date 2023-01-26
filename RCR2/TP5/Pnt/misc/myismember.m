function p = myismember(a,A)
% MYISMEMBER Is 'a' an element of a set of positive integers? (much faster than built-in ismember)
% p = myismember(a,A)

if isempty(A) | a<min(A) | a>max(A) 
  p = 0;
else
  bits = zeros(1, max(A));
  bits(A) = 1;
  p = bits(a);
end
