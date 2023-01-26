function [consistency, cap_max]=very_fast_check_beta(pot_parents,clpot,ns,parent_clusters,alpha);


%This procedure allows to check if it is necessary to add links between clusters to save the degree beta 
%by testing if this degree already exists in the parent clusters 

%!!Principle: computes the joint distribution relative to parent_clusters and test the degree beta

%pot_parents: the potential of parents 
%clpot{i}: contains the domain, the size and the potential of the cluster i
%ns: node sizes
%parent_clusters: the parent clusters
%alpha: the degree alpha

%'--------------------------------------------------------------------------------------'

cap_max=0;

%'---------------------Computing big_domain relative to parents clusters----------------------'

big_domain=[];

for i=1:length(parent_clusters)
   
   big_domain=  myunion(big_domain, clpot{parent_clusters(i)}.domain);
   
end

if prod(ns(big_domain)) > 7000000
    
 cap_max=1;
 consistency=0;

else

big_potential=dpot(big_domain, ns(big_domain));

for i=1:length(parent_clusters)
    big_potential=minimize_by_pot(big_potential,clpot{parent_clusters(i)});
end

pot_parents_from_parents=pot_parents;

pot_parents_from_parents=marginalize_pot(big_potential,pot_parents.domain);

consistency=test_equality(pot_parents,pot_parents_from_parents);

end

