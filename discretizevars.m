%% discretize sample variable
%% uses knee_pt package: https://www.mathworks.com/matlabcentral/fileexchange/35094-knee-point
opts=detectImportOptions('bk10-16.csv');
bk=readtable('bk10-16.csv',opts);
bk(:,44:end)=[]; %% only for one year for now
addpath('knee_pt')
%% normalize with log (+1 to deal with 0s)
bk.LotArea2016=log(bk.LotArea2016+1);

%% Test k means with 1-50 clusters, return total SSE
for i=1:50
    [idx{i},C{i},sumd{i}]=kmeans(bk.LotArea2016,i);
    SSE(i)=sum(sumd{i});
end
%% Calculate the knee point (starts at three, b/c first few clusters are often outliers due to # of zeros)
k=knee_pt(SSE(3:end),[3:50])

%% Creates new categorical variable
bk.LotArea2016c=kmeans(bk.LotArea2016,k);

%% some visualizations to see clusters
scatter(bk.BldgArea2016,bk.BldgArea2016,36,bk.LotArea2016c)
figure
plot([1:50],SSE)

%% loop over all numeric variables
clear all
opts=detectImportOptions('bk10-16.csv');
bk=readtable('bk10-16.csv',opts);
bk(:,44:end)=[]; %% only for one year for now
addpath('knee_pt')
%% Price and Area variables
index=[9:23 25:28 40]
for i=1:size(index,2)
    x=index(i);
    a=table2array(bk(:,x));
    a=log(a+1);
    for j=1:50
        [idx{j},C{j},sumd{j}]=kmeans(a,j);
        SSE(j)=sum(sumd{j});
    end
    k=knee_pt(SSE(3:end),[3:50])
    bk(:,x)=array2table(kmeans(a,k));
end

%% Date and FAR variables
Dedges=[0 1920:10:2020]
a=discretize(bk.YearBuilt2016,Dedges);
bk.YearBuilt2016=a
a=discretize(bk.YearAlter12016,Dedges);
bk.YearAlter12016=a
a=discretize(bk.YearAlter22016,Dedges);
bk.YearAlter22016=a

Fedges=[0:10]
a=discretize(bk.BuiltFAR2016,Fedges)
bk.BuiltFAR2016=a
a=discretize(bk.MaxAllwFAR2016,Fedges)
bk.MaxAllwFAR2016=a
