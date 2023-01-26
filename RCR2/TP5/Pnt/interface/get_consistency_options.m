global ck_cst nb_nodes nodes_type 

nb_nodes=1; %val par defaut
nodes_type ='neighbors'; %val par defaut

ck_cst_yes=get(h_yes,'Value');
ck_cst_no=get(h_no,'Value');


if ck_cst_no==1  %on dde stabilité
    close; 
    ck_cst=0;
    define_stability_options;
else %on ne dde pas de stabilité
    close;
    define_cst_options;
end


   
