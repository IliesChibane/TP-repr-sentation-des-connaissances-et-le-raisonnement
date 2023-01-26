function clpot=very_fast_modify_pot(clpot, ps, alpha, ns);

%clpot:inconsistent cluster
%ps:parent set
%alpha:degree alpha
%ns:nodes sizes

%This procedure changes the enforces the consistency of an inconsistent cluster clpot
%For instance let 
%clpot.T=
%0 0 0.9 0
%0 0 0.8 0.9
%clpot.domain= 2 3 4
%clpot.sizes= 2 2 2

%Then we want to transform clpot.T into:
%0 0.9 0.9 0
%0 0   0.9 0.9

%The principle is 
%1) Compute the  parents potential from clpot.T (potparents) and to detect the position of max elements (pos)
%potparets=0.9 0             and pos= 2 1
%          0.8 0.9                    2 2
%2)Detect inconsitent elements in potparets (inconsistent_index=[2 3])
%3)detect the position of these elements in clpot.T (inconsistent_pos=[2 1])
%4) Update inconsistent_index to be conform with clpot.T: update_index=inconsistent_index+(((inconsistent_pos)-1)*decalage);
%update_index=[6 3]
%decalage denodes the interval between the same configurations of parents in clpot.T
%note that inconsitent_index contains the first position in clpot.T of each inconsitent instance of parents
%5) Transform the elements in the positions update_index into alpha

%'----------------------------------------------------------------------------------------------------------------------------'

dom = clpot.domain;

decalage=prod(ns(ps));

position_node_clpot=length(clpot.domain); %last node in clpot.domain

[potparents,pos]=max(clpot.T,[],position_node_clpot); %we are sure that the last is the children of the rest nodes

inconsistent_index=find(potparents<alpha);

inconsistent_pos=pos([inconsistent_index]);

update_index=inconsistent_index+(((inconsistent_pos)-1)*decalage);

clpot.T([update_index])=alpha;



