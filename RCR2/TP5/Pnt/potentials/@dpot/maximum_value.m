function max_val = maximum_value(clpot, C)

if nargin==2

max_val=0;
inter=cell(C,C);

inter=max(clpot.T);
vinter=inter(:,:);
max_val=max(vinter);

else
    
    max_val=0;

inter=max(clpot.T);
vinter=inter(:,:);
max_val=max(vinter);

end





