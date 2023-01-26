global mat nbn hand dag nodes evidence interest

%mat: matrix of names
%nbn: nb of nodes
%hand: caracteristics of nodes
%dag: DAG

%-------------------------------------------------------------
c=-1;                                   
d=-1;
while (c<40) | (c>760) | (d<20) | (d>580)
   [c d]=ginput(gcf);
end

%---------------------------Question---------------------------

question='Give the name of the node :';
titre='New node';
def={''};
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';

reponse=upper(inputdlg(question,titre,1,def,AddOpts));  

%----------------------------Test-------------------------------

if ~isempty(reponse)

if  isequal(reponse,{''})
     reponse{1}='';
end
 
   
while isequal(reponse{1},'') | existe(reponse) 
   question='Existing or invalid name :';
   reponse=inputdlg(question,titre,1,def,AddOpts);
 if  isempty(reponse)
     reponse{1}='';
 end
 
end

 
%----------------------------dessin-------------------------------
%      reponse{1}=reponse{1}(1:2);
%      h1=rectangle('Curvature',[1 1],'Position',[c d 70 50],'Edgecolor',[0.5 0.5 .5],'LineWidth',.5);  %draw node
%      h2=text(c+28,d+25,reponse{1});  %add text to node
      [t,wd] =textoval(c, d, reponse);
   
%----------------------------save information---------------------
           
      nbn=nbn+1;
      evidence{nbn}=[];
      interest{nbn}=[];
      nodes=1:nbn;
      mat{nbn}.name=reponse{1};
      mat{nbn}.place=nbn;

      hand{nbn}.rec=t(1);
      hand{nbn}.tex=t(2);
      hand{nbn}.pos=[c d];
      hand{nbn}.dim=wd;
      
      dag(nbn,1:nbn)=0;
      dag(nbn,nbn)=0;

%----------------------------choice of parents-------------------
      
      if nbn>1  %the node is not the first one
          %names=[];
          %for i=1:nbn-1
          %    names=[names mat{i}.name]
          %end
          %   [liste,ok]=listdlg('ListString',names','Name','Selection of parents..','ListSize', [260 150]);
 
          names='';
          for i=1:nbn-1
              names{i}= mat{i}.name;
          end
          
         
         [liste,ok]=listdlg('ListString',names,'Name','Selection of parents..','ListSize', [260 150]);
         if ~isempty(liste)
            for i=1:length(liste)
               dag(liste(i),nbn)=1;
            end
               raffraichir;
         end
      end
      
%--------------------------------- 

end %~isempty(reponse)

