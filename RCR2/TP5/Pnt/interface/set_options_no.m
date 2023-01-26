  global ck_cst_no
  
   ck_cst_no = get(h_no,'Value')
   
   hRadiobutton1=findobj('Tag','Radiobutton1')
   
   if ck_cst_no==1

   set(hRadiobutton1,'Enable','off');
   set(hRadiobutton1,'Value',0);

   
   else
    
   set(hRadiobutton1,'Enable','on');
   set(hRadiobutton1,'Value',1);

   end