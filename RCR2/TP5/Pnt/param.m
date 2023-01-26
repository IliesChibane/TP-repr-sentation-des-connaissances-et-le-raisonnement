
nah

%-------------------------------------ALGORITHMS-------------------------------------
%---------------------------------------------------------------------------------------



disp('----------------consistency 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max,nb_add] = global_propagation(engine, evidence_new, [], [], 1, 1, 'neighbors'); t1=toc;
temps1{nb_exemple}=t1
Bel_Cdt=Bel_Cdt_new
cap_max
nb_add

disp('----------------consistency 2-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max] = global_propagation(engine, evidence_new, [], [], 2, 1, 'neighbors'); t1=toc;
temps1{nb_exemple}=t1
Bel_Cdt=Bel_Cdt_new
cap_max


disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t0=toc;
temps0{nb_exemple}=t0
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)


nour
%-------------------------------------ALGORITHMS-------------------------------------
%---------------------------------------------------------------------------------------

disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max] = global_propagation(engine, evidence_new, [], [], 0, 1, 'neighbors'); t1=toc;
temps1{nb_exemple}=t1;
Bel_Cdt=Bel_Cdt_new

disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t0=toc;
temps0{nb_exemple}=t0;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

disp('----------------new 2 parents-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2P{nb_exemple}=t2;
%affichage pour A
Bel_Cdt2P=Bel_Cdt_new
    
if cap_max==1
   cap_max2P=cap_max2P+1
end
    
disp('----------------new 2 children-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2C{nb_exemple}=t2;
%affichage pour A
Bel_Cdt2C=Bel_Cdt_new
        
if cap_max==1
cap_max2C=cap_max2C+1
end
        
disp('----------------new 2 parents-children-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2PC{nb_exemple}=t2;
%affichage pour A
Bel_Cdt2PC=Bel_Cdt_new
        
if cap_max==1
cap_max2PC=cap_max2PC+1
end
        
disp('----------------new 2 neighbors-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2N{nb_exemple}=t2;
%affichage pour A
Bel_Cdt2N=Bel_Cdt_new
       
if cap_max==1
cap_max2N=cap_max2N+1
end
        
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
disp('----------------new 3 parents-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps3P{nb_exemple}=t2;
%affichage pour A
Bel_Cdt3P=Bel_Cdt_new
    
if cap_max==1
cap_max3P=cap_max3P+1
end
    
 disp('----------------new 3 children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt3C=Bel_Cdt_new
        
        if cap_max==1
        cap_max3C=cap_max3C+1
        end
        
 disp('----------------new 3 parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt3PC=Bel_Cdt_new
        
        if cap_max==1
        cap_max3PC=cap_max3PC+1
        end
        
  disp('----------------new 3 neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt3N=Bel_Cdt_new
       
        if cap_max==1
        cap_max3N=cap_max3N+1
        end
        
  %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
   disp('----------------new n-best parents-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_P{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_P=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_best_P=cap_max_n_best_P+1
        end
        
   disp('----------------new n-best children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_C=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_best_C=cap_max_n_best_C+1
        end
        
   disp('----------------new n-best parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_PC=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_best_PC=cap_max_n_best_PC+1
        end
        
   disp('----------------new n-best neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_best_N=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_best_N=cap_max_n_best_N+1
        end
        
   %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
    disp('----------------new n-best parents-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_P{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_P=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_P=cap_max_n_P+1
        end
        
   disp('----------------new n children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_C{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_C=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_C=cap_max_n_C+1
        end
        
    disp('----------------new n parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_PC{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_PC=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_PC=cap_max_n_PC+1
        end
        
    disp('----------------new n neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_N{nb_exemple}=t2;
        %affichage pour A
        Bel_Cdt_n_N=Bel_Cdt_new
        
         if cap_max==1
        cap_max_n_N=cap_max_n_N+1
        end