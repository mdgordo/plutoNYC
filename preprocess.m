%% load data
bk16=readtable('BK16.csv');
bk15=readtable('BK15.csv');
bk14=readtable('BK14.csv');
opts=detectImportOptions('BK13.csv');
bk13=readtable('BK13.csv',opts);
opts=detectImportOptions('BK12.txt');
bk12=readtable('BK12.txt',opts);
opts=detectImportOptions('BK11.txt');
bk11=readtable('BK11.txt',opts);
opts=detectImportOptions('BK10.txt');
bk10=readtable('BK10.txt',opts);

%% delete extra variables
bk16.Borough=[];
bk16.Council=[]; 
bk16.FireComp=[]; 
bk16.PolicePrct=[]; 
bk16.HealthArea=[]; 
bk16.SanitBoro=[]; 
bk16.SanitDistrict=[]; 
bk16.SanitSub=[]; 
bk16.Address=[]; 
bk16.ZoneDist2=[]; 
bk16.ZoneDist3=[]; 
bk16.ZoneDist4=[]; 
bk16.Overlay1=[]; 
bk16.Overlay2=[]; 
bk16.SPDist1=[]; 
bk16.SPDist2=[]; 
bk16.SPDist3=[]; 
bk16.LtdHeight=[]; 
bk16.SplitZone=[]; 
bk16.Easements=[]; 
bk16.OwnerType=[];
bk16.OwnerName=[]; 
bk16.AreaSource=[]; 
bk16.LotDepth=[]; 
bk16.BldgFront=[]; 
bk16.BldgDepth=[]; 
bk16.Ext=[]; 
bk16.ProxCode=[]; 
bk16.IrrLotCode=[]; 
bk16.BsmtCode=[]; 
bk16.BBL=[]; 
bk16.Tract2010=[]; 
bk16.ZoneMap=[]; 
bk16.ZMCode=[]; 
bk16.Sanborn=[]; 
bk16.TaxMap=[]; 
bk16.EDesigNum=[]; 
bk16.APPBBL=[]; 
bk16.APPDate=[]; 
bk16.PLUTOMapID=[]; 
bk16.Version=[];

%% add year
Year=repmat(2016,size(bk16,1),1);
bk16=[bk16 table(Year)];

%% historic/landmark flag
historicflag=zeros(size(bk16,1),1);
historicflag(ismissing(bk16.HistDist)==0)=1;
landmarkflag=zeros(size(bk16,1),1);
landmarkflag(ismissing(bk16.Landmark)==0)=1;
bk16.Landmark=[];
bk16.HistDist=[];
bk16=[bk16 table(historicflag) table(landmarkflag)];

%% Zoning District
% Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
% Commercial-4, Misc Commercial-5, Residential low density-6, Residential
% mid density-7, Residential high density-8, all other-9
% note most Neighborhood Retail exists in Residentially zoned districts
% with commercial overlays
Z=char(bk16.ZoneDist1);
Zoning=ones(size(bk16,1),1);
for i=1:size(bk16,1)
    if strcmp(Z(i,1),'M')==1
        Zoning(i,1)=1;
    else
        if strcmp(Z(i,1),'C')==1
            if strcmp(Z(i,2),'1')==1 | strcmp(Z(i,2),'2')==1
                Zoning(i,1)=2;
            else if strcmp(Z(i,2),'4')==1 | strcmp(Z(i,2),'5')==1
                    Zoning(i,1)=3;
                else if strcmp(Z(i,2),'6')==1 
                        Zoning(i,1)=4;
                    else Zoning(i,1)=5;
                    end
                end
            end                
        else
            if strcmp(Z(i,1),'R')==1
                if (strcmp(Z(i,2),'1')==1 & ~strcmp(Z(i,3),'0')==1) | strcmp(Z(i,2),'2')==1 | strcmp(Z(i,2),'3')==1
                    Zoning(i,1)=6;
                else if strcmp(Z(i,2),'4')==1 | strcmp(Z(i,2),'5')==1 | strcmp(Z(i,2),'6')==1
                    Zoning(i,1)=7;
                    else Zoning(i,1)=8;
                    end
                end
            else
                Zoning(i,1)=9;
            end
        end
    end
end

bk16.ZoneDist1=[];
bk16=[bk16 table(Zoning)];

%% Building Class
% One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
% Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
BC=char(bk16.BldgClass);
BuildingClass=ones(size(bk16,1),1);
for i=1:size(bk16,1)
    if strcmp(BC(i,1),'A')==1 | strcmp(BC(i,1),'B')==1
        BuildingClass(i,1)=1;
    else if strcmp(BC(i,1),'C')==1 | strcmp(BC(i,1),'D')==1 | strcmp(BC(i,1),'S')==1 
            BuildingClass(i,1)=2;
        else if strcmp(BC(i,1),'R')==1 
                BuildingClass(i,1)=3;
            else if strcmp(BC(i,1),'E')==1 | strcmp(BC(i,1),'F')==1 | strcmp(BC(i,1),'G')==1 | strcmp(BC(i,1),'L')==1
                    BuildingClass(i,1)=4;
                else if strcmp(BC(i,1),'K')==1
                        BuildingClass(i,1)=5;
                    else if strcmp(BC(i,1),'H')==1
                            BuildingClass(i,1)=6;
                        else if strcmp(BC(i,1),'I')==1 | strcmp(BC(i,1),'N')==1 | strcmp(BC(i,1),'M')==1 | strcmp(BC(i,1),'J')==1
                                BuildingClass(i,1)=7;
                            else if strcmp(BC(i,1),'O')==1
                                    BuildingClass(i,1)=8;
                                else if strcmp(BC(i,1),'V')==1
                                        BuildingClass(i,1)=9;
                                    else BuildingClass(i,1)=10;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

bk16.BldgClass=[];
bk16=[bk16 table(BuildingClass)];
            
%% create value per square foot
% special treatment of condos and vacant land? 

ValPSF=(bk16.AssessTot-bk16.AssessLand)./bk16.BldgArea;
ValPSF(isnan(ValPSF)==1)=0;
ValPSF(isinf(ValPSF)==1)=0;
bk16=[bk16 table(ValPSF)];

%% drop rows with missing data
bk16=rmmissing(bk16);
%%
writetable(bk16,'bk16clean.csv')
