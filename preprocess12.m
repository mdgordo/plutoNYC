%% delete extra variables
% Note: 12 and earlier have only 2 FAR variables instead of 4
bk12.Borough=[];
bk12.Council=[]; 
bk12.FireComp=[]; 
bk12.PolicePrct=[]; 
bk12.Address=[]; 
bk12.ZoneDist2=[]; 
bk12.ZoneDist3=[]; 
bk12.ZoneDist4=[];
bk12.AllZoning1=[];
bk12.AllZoning2=[];
bk12.BuiltCode=[];
bk12.Overlay1=[]; 
bk12.Overlay2=[]; 
bk12.SPDist1=[]; 
bk12.SPDist2=[]; 
bk12.LtdHeight=[]; 
bk12.SplitZone=[]; 
bk12.Easements=[]; 
bk12.OwnerType=[];
bk12.OwnerName=[]; 
bk12.AreaSource=[]; 
bk12.LotDepth=[]; 
bk12.BldgFront=[]; 
bk12.BldgDepth=[]; 
bk12.Ext=[]; 
bk12.ProxCode=[]; 
bk12.IrrLotCode=[]; 
bk12.BsmtCode=[]; 
bk12.BBL=[]; 
bk12.Tract2010=[]; 
bk12.ZoneMap=[]; 
bk12.ZMCode=[]; 
bk12.Sanborn=[]; 
bk12.TaxMap=[]; 
bk12.EDesigNum=[]; 
bk12.APPBBL=[]; 
bk12.APPDate=[]; 
bk12.PLUTOMapID=[]; 
bk12.Version=[];

%% add year
Year=repmat(2012,size(bk12,1),1);
bk12=[bk12 table(Year)];

%% historic/landmark flag
historicflag=zeros(size(bk12,1),1);
for i=1:size(bk12,1)
    if sum(isletter(bk12.HistDist{i}))==0
        historicflag(i,1)=0;
    else historicflag(i,1)=1;
    end
end
        
landmarkflag=zeros(size(bk12,1),1);
for i=1:size(bk12,1)
    if sum(isletter(bk12.Landmark{i}))==0
        landmarkflag(i,1)=0;
    else landmarkflag(i,1)=1;
    end
end

bk12.Landmark=[];
bk12.HistDist=[];
bk12=[bk12 table(historicflag) table(landmarkflag)];


%% Zoning District
% Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
% Commercial-4, Misc Commercial-5, Residential low density-6, Residential
% mid density-7, Residential high density-8, all other-9
% note most Neighborhood Retail exists in Residentially zoned districts
% with commercial overlays
Z=char(bk12.ZoneDist1);
Zoning=ones(size(bk12,1),1);
for i=1:size(bk12,1)
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

bk12.ZoneDist1=[];
bk12=[bk12 table(Zoning)];

%% Building Class
% One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
% Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
BC=char(bk12.BldgClass);
BuildingClass=ones(size(bk12,1),1);
for i=1:size(bk12,1)
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

bk12.BldgClass=[];
bk12=[bk12 table(BuildingClass)];         

%% create value per square foot
% special treatment of condos and vacant land? 

ValPSF=bk12.AssessTot./bk12.BldgArea;
ValPSF(isnan(ValPSF)==1)=0;
ValPSF(isinf(ValPSF)==1)=0;
bk12=[bk12 table(ValPSF)];

%% drop rows with missing data
bk12=rmmissing(bk12);
%%
writetable(bk12,'bk12clean.csv')
