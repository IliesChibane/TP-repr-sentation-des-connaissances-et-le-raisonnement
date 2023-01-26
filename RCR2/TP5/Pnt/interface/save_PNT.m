
global filename path

[filename,path]=uiputfile('*.mat','Save as...');
  


  if filename~=0
            
  eval(['save ',path,filename,...
           ' hand mat dag nbn node_sizes sauv_node_sizes pnet order evidence  interest']);

  end
   
