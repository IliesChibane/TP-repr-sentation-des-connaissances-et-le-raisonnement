global mat nbn matrice
nbn=2;
mat{1}='a';
mat{2}='b';
matrice(nbn,1:nbn)=0;
matrice = zeros(nbn,nbn);
matrice(1,2)=1;

if nbn>=1
[noeud,ok1]=listdlg('ListString',mat(1:nbn),'Name','Selection du noeud..','SelectionMode','single');
nom=mat{noeud};
question=strcat('Donner le nombre d''états que peut prendre le noeud ',nom); 
dlgTitle='Nombre d''états';
lineNo=1;
addopts.Resize='on';
addopts.WindowStyle='normal';
addopts.Interpreter='none';
def={'2'};
rep=inputdlg(question,dlgTitle,lineNo,def,addopts)
i=str2num(rep{1})%str2num(answer(1));
t=probas(nom,i);
end
