function rep=probas(nom,i)
%clear prompt;
   for k=1:i
      chaine=strcat('Donner la proba de ',nom,'_',num2str(k));
      prompt{k}=chaine;
      def{k}='1';
   end
dlgTitle='Saisie des probabilités';
lineNo=1;
addopts.Resize='on';
addopts.WindowStyle='normal';
addopts.Interpreter='none';
rep=inputdlg(prompt,dlgTitle,lineNo,def,addopts)