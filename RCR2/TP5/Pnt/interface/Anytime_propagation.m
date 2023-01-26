%this procedure is called in get_stability options

engine = MG_inf_engine(pnet);

[Poss_degree, best_instances, cap_max,nb_add] = global_propagation(engine, evidence, interest, ck_cst,nb_nodes,nodes_type );

if cap_max==1
    
msgbox('You have exceed the capacity of the system');

else
    
%-------------------------------------------------DISPLAY RESULT------------------------------------------------

if ~isempty(find(~isemptycell(evidence)))  %1
    
    
    if ~isempty(find(~isemptycell(interest))) %2
        
    x= ' ';
    e= ' ';
  for i=1:length(interest)
    if ~isempty(interest{i})
    y=mat{i}.name;
    z=strcat(lower(y), '_', num2str(interest{i}));
    x=strcat(x, ' ', z);
    else
    if ~isempty(evidence{i})
    w=mat{i}.name;
    v=strcat(lower(w), '_', num2str(evidence{i}));
    e=strcat(e, ' ', v);
    end
    end
  end
  
  x=[' ' x];
  
  e=[' ' e];  

  y=[' ' num2str(Poss_degree)];

  msgbox(strcat('The possibility degree of ', x, ' in context of ', e, ' is ', y), 'Result');

%-----------------------------------------------------------------------------------------------------------------
  
    else  %interest empty  
        
    x=' ';
    for i=1:length(evidence)
    if ~isempty(evidence{i})
    w=mat{i}.name;
    v=strcat(lower(w), '_', num2str(evidence{i}));
    x=strcat(x, ' ', v);
    end
    end
    
    x=[' ' x];
                
        for i=1:nbn
            if isempty(evidence{i})
                y=[' ', mat{i}.name];
                z=strcat(lower(y), '_', num2str(best_instances{i}));
                z=[' ', z];
                uiwait(msgbox(strcat('Best instance(s) of ', y, ' in context of ', x, ' is(are) ', z), 'Result'));
            end
        end
             
    end
%-----------------------------------------------------------------------------------------------------------------
    
    else %evidence empty %1
       
        if   ~isempty(find(~isemptycell(interest)))  %3
            
        x= ' ';
        for i=1:length(interest)
            if ~isempty(interest{i})
            y=mat{i}.name;
            z=strcat(lower(y), '_', num2str(interest{i}));
            x=strcat(x, ' ', z);
        end
        end

        x=[' ' x]

        y=[' ' num2str(Poss_degree)];

        msgbox(strcat('The possibility degree of ', x, ' is ', y), 'Result');      

%-----------------------------------------------------------------------------------------------------------------
        
        else %evidence empty +interest empty %manque les instances
            
         for i=1:nbn
                y=[' ', mat{i}.name];
                z=strcat(lower(y), '_', num2str(best_instances{i}));
                z=[' ', z];
                uiwait(msgbox(strcat('Best instance(s) of ', y, ' is(are) ', z), 'Result'));

        end
     
        end%3
    end

end

