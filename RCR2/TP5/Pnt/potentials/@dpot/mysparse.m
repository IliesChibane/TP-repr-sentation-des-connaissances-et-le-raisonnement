function new_form= mysparse(clpot)

clpot.T(:,:)
new_form=sparse(clpot.T(:,:));

