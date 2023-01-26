function [Poss_degree, best_instances, cap_max,nb_add] = global_propagation(engine, evidence, interest, ck_cst, nb_nodes,nodes_type)

%main program

%----------------------------------------------------------------------------

Poss_degree=[];
best_instances=[];
nb_add=0;

%----------------test of input variables-------------------------------------

test_input=1;
if ~ismember(ck_cst,[0 1 2]) 
   disp('The checking consistency option (ck_cst) is not specified');
   test_input=0;
else     
  % if isempty(nb_nodes) & ~isequal(nodes_type,'neighbors')
   if ~isequal(nb_nodes,1) & ~isequal(nb_nodes,2) & ~isequal(nb_nodes,3)  & ~isequal(nb_nodes,'n_best') & ~isequal(nb_nodes,'n')
      disp('The stability option (nb_nodes) is not specified');
      test_input=0;
   else
   	if ~isequal(nodes_type,'parents') & ~isequal(nodes_type,'children') & ~isequal(nodes_type, 'parents_children') & ~isequal(nodes_type,'neighbors')
      disp('The stability option (nodes_type) is not specified');
      test_input=0;
   end
end
end

if test_input==1  %the input variables are correct
   
pnet = pnet_from_engine(engine);
ns = pnet.node_sizes(:);
N = length(pnet.dag);

CPDpot = cell(1,N);
for n=1:N
  fam = family(pnet.dag, n);
  e = pnet.equiv_class(n);
  CPDpot{n} = CPD_to_dpot(pnet.CPD{e}, fam, ns);
end


if ~isempty(find(~isemptycell(evidence)))  %1
    
    
    if ~isempty(find(~isemptycell(interest))) %2
        
   
    [engine, pnet, Bel_evidence,clpot, cap_max,nb_add] = enter_instance(engine,  pnet, CPDpot, evidence, ck_cst, nb_nodes,nodes_type,nb_add) ;
    [engine, pnet, Bel_joint_interest_evidence,clpot, cap_max,nb_add] = enter_instance(engine,  pnet, clpot, interest, ck_cst, nb_nodes,nodes_type,nb_add) ;
    
   %------------Normalization
  %  if Bel_joint_interest_evidence == Bel_evidence
  %          Poss_degree=1;
  %      else
  %          Poss_degree= Bel_joint_interest_evidence;
  %  end
  
  Poss_degree=Bel_joint_interest_evidence;

    else  %interest empty  %2

    [engine, pnet, Poss_degree ,clpot, cap_max,nb_add] = enter_instance(engine,  pnet, CPDpot, evidence, ck_cst, nb_nodes,nodes_type,nb_add) ;
    
    best_instances=define_best_instances(clpot{1}, clpot, N, Poss_degree); %clpot{1} inutile
    
    end
    
    else %evidence empty %1
        
       
        if   ~isempty(find(~isemptycell(interest)))  %3
            
               
              [engine, pnet, Poss_degree ,clpot, cap_max,nb_add] = enter_instance(engine,  pnet, CPDpot, interest, ck_cst, nb_nodes,nodes_type,nb_add) ;
              
                           
        else %evidence empty +interest empty%3
            
           [engine, pnet, Poss_degree,clpot, cap_max,nb_add] = enter_instance(engine,  pnet, CPDpot, evidence, ck_cst, nb_nodes,nodes_type,nb_add) ;
           
           best_instances=define_best_instances(clpot{1}, clpot, N, Poss_degree); %clpot{1} inutile
            
        end%3
    end

end %input variables are correct


   