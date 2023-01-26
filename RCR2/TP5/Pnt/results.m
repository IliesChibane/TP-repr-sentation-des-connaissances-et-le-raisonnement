

x=load('c:\anahla\level_19_2');

whole=[];

a=x.temps0;
t0=0;
for i=1:length(a)
    t0=t0+x.temps0{i};
end
t0=t0/length(a);

whole=[whole t0];

a=x.temps1;
t1=0;
for i=1:length(a)
    t1=t1+x.temps1{i};
end
t1=t1/length(a);

whole=[whole t1];

a=x.temps2;
t2=0;
for i=1:length(a)
    if ~isempty(x.temps2{i})
    t2=t2+x.temps2{i};
end
end
t2=t2/length(a);

whole=[whole t2];

a=x.temps3;
t3=0;
for i=1:length(a)
    if ~isempty(x.temps3{i})
    t3=t3+x.temps3{i};
    end
end
t3=t3/length(a);

whole=[whole t3];

a=x.temps_n_best;
t_n_best=0;
for i=1:length(a)
     if ~isempty(x.temps_n_best{i})
    t_n_best=t_n_best+x.temps_n_best{i};
end
end
t_n_best=t_n_best/length(a);

whole=[whole t_n_best]


