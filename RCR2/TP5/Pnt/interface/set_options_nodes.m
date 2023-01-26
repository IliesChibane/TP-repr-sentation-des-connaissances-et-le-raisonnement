  
   one = get(hh1,'Value')
   
   hPopupMenu2=findobj('Tag','PopupMenu2')

   if one==1

   set(hPopupMenu2,'Enable','off');
      
   else
    
   set(hPopupMenu2,'Enable','on');

   end