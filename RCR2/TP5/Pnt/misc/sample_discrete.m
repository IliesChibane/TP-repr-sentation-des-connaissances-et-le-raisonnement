function M = sample_discrete(prob, r, c)
% SAMPLE_DISCRETE Like the built in 'rand', except we draw from a non-uniform discrete distrib.
% M = sample_discrete(prob, r, c)
%
% Example: sample_discrete([0.8 0.2], 1, 10) generates a row vector of 10 random integers from {1,2},
% where the prob. of being 1 is 0.8 and the prob of being 2 is 0.2.

if nargin == 1
  r = 1; c = 1;
elseif nargin == 2
  c == r;
end

% this speedup is due to Peter Acklam
cumprob = cumsum(prob(:));
n = length(cumprob);
R = rand(r, c);
M = ones(r, c);
for i = 1:n-1
  M = M + (R > cumprob(i));
end

%R = rand(r, c);
%n = length(prob);
%cumprob = reshape(cumsum([0 prob(1:end-1)]), [1 1 n]);
%M = sum(R(:,:,ones(n,1)) > cumprob(ones(r,1),ones(c,1),:), 3);

