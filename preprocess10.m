%% delete extra variables
% Note: 12 and earlier have only 2 FAR variables instead of 4
bk10.Borough=[];
bk10.Council=[]; 
bk10.FireComp=[]; 
bk10.PolicePrct=[];
bk10.HealthCtr=[];
bk10.HealthArea=[];
bk10.Address=[]; 
bk10.ZoneDist2=[]; 
bk10.ZoneDist3=[]; 
bk10.ZoneDist4=[];
bk10.AllZoning1=[];
bk10.AllZoning2=[];
bk10.BuiltCode=[];
bk10.Overlay1=[]; 
bk10.Overlay2=[]; 
bk10.SPDist1=[]; 
bk10.SPDist2=[]; 
bk10.LtdHeight=[]; 
bk10.SplitZone=[]; 
bk10.Easements=[]; 
bk10.OwnerType=[];
bk10.OwnerName=[]; 
bk10.AreaSource=[]; 
bk10.LotDepth=[]; 
bk10.BldgFront=[]; 
bk10.BldgDepth=[]; 
bk10.ProxCode=[]; 
bk10.IrrLotCode=[]; 
bk10.BsmtCode=[]; 
bk10.BBL=[]; 
bk10.Tract2000=[]; 
bk10.ZoneMap=[]; 
bk10.ZMCode=[]; 
bk10.Sanborn=[]; 
bk10.TaxMap=[]; 
bk10.EDesigNum=[]; 
bk10.APPBBL=[]; 
bk10.APPDate=[]; 
bk10.PLUTOMapID=[]; 
bk10.RPADDate=[]; 
bk10.DCASDate=[]; 
bk10.ZoningDate=[]; 
bk10.MajPrpDate=[]; 
bk10.LandmkDate=[]; 
bk10.MASDate=[];
bk10.PoliDate=[]; 
bk10.EDesigDate=[]; 
bk10.DTMDate=[]; 


%% add year
Year=repmat(2010,size(bk10,1),1);
bk10=[bk10 table(Year)];

%% historic/landmark flag
historicflag=zeros(size(bk10,1),1);
for i=1:size(bk10,1)
    if sum(isletter(bk10.HistDist{i}))==0
        historicflag(i,1)=0;
    else historicflag(i,1)=1;
    end
end
        
landmarkflag=zeros(size(bk10,1),1);
for i=1:size(bk10,1)
    if sum(isletter(bk10.Landmark{i}))==0
        landmarkflag(i,1)=0;
    else landmarkflag(i,1)=1;
    end
end

bk10.Landmark=[];
bk10.HistDist=[];
bk10=[bk10 table(historicflag) table(landmarkflag)];

%% Zoning District
% Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
% Commercial-4, Misc Commercial-5, Residential low density-6, Residential
% mid density-7, Residential high density-8, all other-9
% note most Neighborhood Retail exists in Residentially zoned districts
% with commercial overlays
Z=char(bk10.ZoneDist1);
Zoning=ones(size(bk10,1),1);
for i=1:size(bk10,1)
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

bk10.ZoneDist1=[];
bk10=[bk10 table(Zoning)];

%% Building Class
% One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
% Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
BC=char(bk10.BldgClass);
BuildingClass=ones(size(bk10,1),1);
for i=1:size(bk10,1)
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

bk10.BldgClass=[];
bk10=[bk10 table(BuildingClass)];         

%% create value per square foot
% special treatment of condos and vacant land? 


ValPSF=(bk16.AssessTot-bk16.AssessLand)./bk16.BldgArea;
ValPSF(isnan(ValPSF)==1)=0;
ValPSF(isinf(ValPSF)==1)=0;
bk10=[bk10 table(ValPSF)];

%% drop rows with missing data
bk10=rmmissing(bk10);
%%
writetable(bk10,'bk10clean.csv')
