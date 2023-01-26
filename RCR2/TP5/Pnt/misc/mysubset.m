function p=mysubset(small,large)
% MYSUBSET Is the small set of +ve integers a subset of the large set?
% p = mysubset(small, large)

% Surprisingly, this is not built-in.

p = length(myintersect(small,large)) == length(small);

