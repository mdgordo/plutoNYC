%% delete extra variables
% Note: 12 and earlier have only 2 FAR variables instead of 4
bk11.Borough=[];
bk11.CD=[]; 
bk11.CT2010=[]; 
bk11.CB2010=[];
bk11.Council=[]; 
bk11.FireComp=[]; 
bk11.PolicePrct=[];
bk11.HealthCtr=[];
bk11.HealthArea=[];
bk11.Address=[]; 
bk11.ZoneDist2=[]; 
bk11.ZoneDist3=[]; 
bk11.ZoneDist4=[];
bk11.AllZoning1=[];
bk11.AllZoning2=[];
bk11.BuiltCode=[];
bk11.Overlay1=[]; 
bk11.Overlay2=[]; 
bk11.SPDist1=[]; 
bk11.SPDist2=[]; 
bk11.LtdHeight=[]; 
bk11.SplitZone=[]; 
bk11.Easements=[]; 
bk11.OwnerType=[];
bk11.OwnerName=[]; 
bk11.AreaSource=[]; 
bk11.LotDepth=[]; 
bk11.BldgFront=[]; 
bk11.BldgDepth=[]; 
bk11.Ext=[]; 
bk11.ProxCode=[]; 
bk11.IrrLotCode=[]; 
bk11.BsmtCode=[]; 
bk11.BBL=[]; 
bk11.Tract2010=[]; 
bk11.ZoneMap=[]; 
bk11.ZMCode=[]; 
bk11.Sanborn=[]; 
bk11.TaxMap=[]; 
bk11.EDesigNum=[]; 
bk11.APPBBL=[]; 
bk11.APPDate=[]; 
bk11.PLUTOMapID=[]; 
bk11.Version=[];

%% add year
Year=repmat(2011,size(bk11,1),1);
bk11=[bk11 table(Year)];

%% historic/landmark flag
historicflag=zeros(size(bk11,1),1);
for i=1:size(bk11,1)
    if sum(isletter(bk11.HistDist{i}))==0
        historicflag(i,1)=0;
    else historicflag(i,1)=1;
    end
end
        
landmarkflag=zeros(size(bk11,1),1);
for i=1:size(bk11,1)
    if sum(isletter(bk11.Landmark{i}))==0
        landmarkflag(i,1)=0;
    else landmarkflag(i,1)=1;
    end
end

bk11.Landmark=[];
bk11.HistDist=[];
bk11=[bk11 table(historicflag) table(landmarkflag)];

%% Zoning District
% Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
% Commercial-4, Misc Commercial-5, Residential low density-6, Residential
% mid density-7, Residential high density-8, all other-9
% note most Neighborhood Retail exists in Residentially zoned districts
% with commercial overlays
Z=char(bk11.ZoneDist1);
Zoning=ones(size(bk11,1),1);
for i=1:size(bk11,1)
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

bk11.ZoneDist1=[];
bk11=[bk11 table(Zoning)];

%% Building Class
% One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
% Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
BC=char(bk11.BldgClass);
BuildingClass=ones(size(bk11,1),1);
for i=1:size(bk11,1)
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

bk11.BldgClass=[];
bk11=[bk11 table(BuildingClass)];         

%% create value per square foot
% special treatment of condos and vacant land? 

ValPSF=bk11.AssessTot./bk11.BldgArea;
ValPSF(isnan(ValPSF)==1)=0;
ValPSF(isinf(ValPSF)==1)=0;
bk11=[bk11 table(ValPSF)];

%% drop rows with missing data
bk11=rmmissing(bk11);
%%
writetable(bk11,'bk11clean.csv')