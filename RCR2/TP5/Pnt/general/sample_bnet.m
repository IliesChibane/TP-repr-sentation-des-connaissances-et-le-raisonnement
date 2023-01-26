function seq = sample_bnet(bnet, N)
% SAMPLE_BNET Generate a random samples from a Bayes net.
% seq = sample_bnet(bnet, N)
%
% seq{i,l} contains the value of the i'th node in the l'th example.
% There will be N columns. N defaults to 1.

if nargin < 2, N = 1; end

n = length(bnet.dag);
seq = cell(n,N);

for l=1:N
  for i=1:n
    fam = family(bnet.dag, i);
    e = bnet.equiv_class(i);
    seq{i,l} = sample_CPD(bnet.CPD{e}, fam, bnet.node_sizes, bnet.cnodes, seq(:,l));
  end
end
