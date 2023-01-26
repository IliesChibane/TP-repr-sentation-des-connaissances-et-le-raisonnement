function test = check_consistency_cluster(C,clpot,alpha)

test=1; 

min_val=0;
inter=cell(C,C);

inter=min(clpot.T);
vinter=inter(:,:);
min_val=min(vinter);

test=(min_val== alpha);




   
      

      