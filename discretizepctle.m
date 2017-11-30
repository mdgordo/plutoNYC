%% alternate categories using percentiles
%% first percentile includes all observations with value 0
%% if the number of obs with value 0 is much more than obs w value !=0, breaks into smaller number of groups
opts=detectImportOptions('bk10-16.csv');
bk=readtable('bk10-16.csv',opts);
bk(:,44:end)=[]; %% only for one year for now

%% Price and Area variables
index=[9:23 25:28 40]
for i=1:size(index,2)
    x=index(i);
    a=table2array(bk(:,x));
    a=log(a+1);
    z=a==0;
    edges=prctile(a(z==0),[10:10:100]);
    edges(1)=0;
    d=discretize(a,edges);
    u=unique(d);
    for i=1:size(u,1)
        d(d==u(i))=i;
    end
    o=sum(d==1);
    g=sum(d>1);
    if o>100*g
        d(d>1)=2;
    else if o>10*g
        d(d>1&d<5)=2;
        d(d>=5&d<8)=3;
        d(d>=8)=4;
        else
        end
    end
    bk(:,x)=array2table(d);
end

%% Date and FAR variables
Dedges=[0 1920:10:2020]
a=discretize(bk.YearBuilt2016,Dedges);
bk.YearBuilt2016=a;
a=discretize(bk.YearAlter12016,Dedges);
bk.YearAlter12016=a;
a=discretize(bk.YearAlter22016,Dedges);
bk.YearAlter22016=a;

Fedges=[0:10]
a=discretize(bk.BuiltFAR2016,Fedges);
bk.BuiltFAR2016=a;
a=discretize(bk.MaxAllwFAR2016,Fedges);
bk.MaxAllwFAR2016=a;

%%
writetable(bk,'bk16_catpctle.csv')