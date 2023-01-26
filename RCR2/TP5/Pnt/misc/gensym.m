function x = gensym()
% GENSYM Generate a unique integer
% x = gensym()
%
% Every time this is called, it generates a new integer, which can be used to create unique names.

global GENSYM; % we could use persistent, but this only supported in >=5.2
if isempty(GENSYM)
  GENSYM = 1;
end
x = GENSYM;
GENSYM = GENSYM + 1;
