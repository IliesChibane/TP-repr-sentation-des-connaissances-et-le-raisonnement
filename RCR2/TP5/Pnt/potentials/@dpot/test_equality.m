function [equal] = test_equality(pot1, pot2)

equal=1;


if ~isequal(pot1.T,pot2.T)
   equal=0;
   
end;
