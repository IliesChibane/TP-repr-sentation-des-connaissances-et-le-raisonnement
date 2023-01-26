global hand mat dag nbn node_sizes sauv_node_sizes pnet order evidence  interest 

[filename,path]=uigetfile('*.mat','Open File');
  
  if filename~=0
 
  for i=1:nbn    
   delete(hand{i}.rec);
   delete(hand{i}.tex);
  end

  eval(['load ',path,filename,';']);
  
  %drawing  
  
  for i=1:nbn
       [t,wd]=textoval(hand{i}.pos(1),hand{i}.pos(2),mat{i}.name);
       hand{i}.rec=t(1);
       hand{i}.tex=t(2);
       hand{i}.dim=wd;
       if ~isempty(evidence{i})
           
            col_tex = [0 0 1];
            xx=hand{i}.rec;
            set(xx,'color', 1-col_tex); drawnow;
            yy=hand{i}.tex;
            set(yy,'facecolor', col_tex); drawnow;
       else
       if ~isempty(interest{i})
           col_tex_interest = [1 0 0];
           xx=hand{i}.rec;
           set(xx,'color', 1-col_tex_interest); drawnow;
           yy=hand{i}.tex;
           set(yy,'facecolor', col_tex_interest); drawnow;
       end
       end

  end %for
  

  
  raffraichir;
  
  end