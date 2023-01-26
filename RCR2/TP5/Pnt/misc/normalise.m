function [M] = normalise(M)
% NORMALISE Make the entries of a (multidimensional) array such that the max is equal to 1
% [M] = normalise(M)
%
% This function uses the British spelling to avoid any confusion with
% 'normalize_pot', which is a method for potentials.

c = max(M(:));

[a,b]=size(M);
for i=1:a  
   for j=1:b    
      if M(i,j)==c;
         M(i,j)=1;
      end 
   end
end
