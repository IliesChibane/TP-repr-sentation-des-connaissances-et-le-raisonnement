if nbn ~=0  %exists a current network
    
rep=QUESTDLG('Save changes to current network ?');   

if isequal(rep, 'Yes')
         
    if filename~=0  %we have saved it before
                
        eval(['save ',path,filename,...
           ' hand mat dag nbn node_sizes sauv_node_sizes pnet order evidence  interest']);
    else            %we have not saved it before
   
         save_PNT;
     
    end 
   
close;
    
elseif isequal(rep, 'No')

close;

end

else
    
  close;

end
    




