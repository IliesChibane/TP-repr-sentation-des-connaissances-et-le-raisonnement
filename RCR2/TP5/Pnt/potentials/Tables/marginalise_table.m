function small = marginalise_table(big, ndx, from, onto, ns)
% MARGINALISE_TABLE Marginalise a large table onto a smaller domain
% small = marginalise_table(big, ndx, from, onto, ns)

%small = sum(big(ndx), 2); % doesn't always work!

%sumover = mysetdiff(from, onto);
%temp = myreshape(big, [prod(ns(onto)) prod(ns(sumover))]);
%small = sum(temp(ndx), 2);

% we resort to the slow method, and ignore the ndx argument for now...
temp1 = dpot(from, ns(from), big);
temp2 = marginalize_pot(temp1, onto);
temp3 = struct(temp2);
small = temp3.T;
