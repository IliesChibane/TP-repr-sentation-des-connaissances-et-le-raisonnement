function ndx = subv2ind(siz, subv)
% SUBV2IND Like the built-in sub2ind, but the subscripts are given as row vectors.
% ind = subv2ind(siz,subv)
%
% siz can be a row or column vector of size d.
% subv should be a collection of N row vectors of size d.
% ind will be of size 1 * N.
%
% Example:
% subv = [1 1 1;
%         2 1 1;
%         ...
%         2 2 2];
% subv2ind([2 2 2], subv) returns [1 2 ... 8]
% i.e., the leftmost digit toggles fastest.
%
% See also IND2SUBV.

if isempty(subv)
  ndx = [];
  return;
end

if isempty(siz)
  ndx = 1;
  return;
end

[nindices ndims] = size(subv);
assert(length(siz) == ndims);

if all(siz==2)
  ndx = bitv2dec(subv(:,end:-1:1)-1)+1;
  ndx = ndx(:)';
  return;
end

siz = siz(:)';
k = [1 cumprod(siz(1:end-1))];
ndx = ones(nindices, 1);
for i = 1:ndims,
  ndx = ndx + (subv(:,i)-1)*k(i);
end
ndx = ndx(:)';

%%%%%%%%%%%

function d = bitv2dec(bits)
% BITV2DEC Convert a bit vector to a decimal integer
% d = butv2dec(bits)
%
% This is just like the built-in bin2dec, except the argument is a vector, not a string.
% If bits is an array, each row will be converted.

[m n] = size(bits);
twos = pow2(n-1:-1:0);
d = sum(bits .* twos(ones(m,1),:),2);
