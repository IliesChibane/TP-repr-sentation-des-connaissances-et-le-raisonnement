function fleche(i,j)
global hand


x1=hand{i}.pos(1);
x2=hand{j}.pos(1);
y1=hand{i}.pos(2);
y2=hand{j}.pos(2);

a1=hand{i}.dim(1);
b1=hand{i}.dim(2);
a2=hand{j}.dim(1);
b2=hand{j}.dim(2);


x=x2-x1;
y=y2-y1;

d=sqrt(x*x+y*y);

cphi=x/d;
sphi=y/d;

debut(1)=x1+a1*cphi;
debut(2)=y1+b1*sphi;

fin(1)=x2-a2*cphi;
fin(2)=y2-b2*sphi;


ARROW('Start',debut,'Stop',fin,'Length',10,'Baseangle',45,'Tipangle',30,'Width',0.3);

