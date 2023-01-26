
disp('----------------new 1-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max] = global_propagation(engine, evidence_new, [], [], 0, 1, 'neighbors'); t1=toc;
temps1{nb_example}=t1;
Bel_Cdt=Bel_Cdt_new


disp('----------------new 2 parents-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2P{nb_example}=t2;
%affichage pour A
Bel_Cdt2P=Bel_Cdt_new
    
if cap_max==1
   cap_max2P=[cap_max2P nb_example]
end
    
disp('----------------new 2 children-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2C{nb_example}=t2;
%affichage pour A
Bel_Cdt2C=Bel_Cdt_new
        
if cap_max==1
cap_max2C=[cap_max2C  nb_example]
end
        
disp('----------------new 2 parents-children-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2PC{nb_example}=t2;
%affichage pour A
Bel_Cdt2PC=Bel_Cdt_new
        
if cap_max==1
cap_max2PC=[cap_max2PC nb_example]
end
        
disp('----------------new 2 neighbors-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 2, 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps2N{nb_example}=t2;
%affichage pour A
Bel_Cdt2N=Bel_Cdt_new
       
if cap_max==1
cap_max2N=[cap_max2N nb_example]
end
        
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
disp('----------------new 3 parents-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
temps3P{nb_example}=t2;
%affichage pour A
Bel_Cdt3P=Bel_Cdt_new
    
if cap_max==1
cap_max3P=[cap_max3P nb_example]
end
    
       disp('----------------new 3 children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3C{nb_example}=t2;
        %affichage pour A
        Bel_Cdt3C=Bel_Cdt_new
        
        if cap_max==1
        cap_max3C=[cap_max3C nb_example]
        end
        
        disp('----------------new 3 parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3PC{nb_example}=t2;
        %affichage pour A
        Bel_Cdt3PC=Bel_Cdt_new
        
        if cap_max==1
        cap_max3PC=[cap_max3PC nb_example]
        cap_max3N=[cap_max3N nb_example]

        else        
        disp('----------------new 3 neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 3, 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps3N{nb_example}=t2;
        %affichage pour A
        Bel_Cdt3N=Bel_Cdt_new
        
        if cap_max==1
        cap_max3N=[cap_max3N nb_example]
        end
               
            end
        
  %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        disp('----------------new n-best parents-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_P{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_best_P=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_best_P=[cap_max_n_best_P nb_example]
        end
        
        disp('----------------new n-best children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_C{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_best_C=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_best_C=[cap_max_n_best_C nb_example]
        end
        
        disp('----------------new n-best parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_PC{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_best_PC=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_best_PC=[cap_max_n_best_PC nb_example]
        cap_max_n_best_N=[cap_max_n_best_N nb_example]
        
        else
               
        disp('----------------new n-best neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n_best', 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_best_N{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_best_N=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_best_N=[cap_max_n_best_N nb_example]
        end
                
        end
        
   %xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        disp('----------------new n-best parents-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'parents'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_P{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_P=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_P=[cap_max_n_P nb_example]
        end
        
        disp('----------------new n children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_C{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_C=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_C=[cap_max_n_C nb_example]
        end
        
        disp('----------------new n parents-children-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'parents_children'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_PC{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_PC=Bel_Cdt_new
        
        if cap_max==1
        cap_max_n_PC=[cap_max_n_PC nb_example]
        cap_max_n_N=[cap_max_n_N nb_example]
        else
        disp('----------------new n neighbors-------------');
        engine = MG_inf_engine(pnet);
        tic; [Bel_Cdt_new,cap_max] = global_propagation(engine, evidence_new, [], [], 0, 'n', 'neighbors'); t2=toc;  %si on veut appeler cette procedure avec neighbors=cs+ps
        temps_n_N{nb_example}=t2;
        %affichage pour A
        Bel_Cdt_n_N=Bel_Cdt_new
        
        if cap_max==1
                cap_max_n_N=[cap_max_n_N nb_example]
        end
            
        
        end
 