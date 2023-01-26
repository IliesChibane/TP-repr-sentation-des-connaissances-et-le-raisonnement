  global  ck_cst_yes
  
   ck_cst_yes = get(h_yes,'Value')
   
   hRadiobutton2=findobj('Tag','Radiobutton2')

   if ck_cst_yes==1

   set(hRadiobutton2,'Enable','off');
   set(hRadiobutton2,'Value',0);

      
   else
    
   set(hRadiobutton2,'Enable','on');
   set(hRadiobutton2,'Value',1);

   end