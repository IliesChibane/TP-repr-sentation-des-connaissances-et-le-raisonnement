function C = cellcat(A,B)
% CELLCAT Returns {A, B} where A and B are cell arrays 
% C = cellcat(A,B)

na = length(A);
nb = length(B);
C = cell(1,na+nb);
C(1:na) = A;
C((na+1):end) = B;
  
