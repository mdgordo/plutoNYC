%% delete extra variables
bk14.Borough=[];
bk14.Council=[]; 
bk14.FireComp=[]; 
bk14.PolicePrct=[]; 
bk14.HealthArea=[]; 
bk14.Address=[]; 
bk14.ZoneDist2=[]; 
bk14.ZoneDist3=[]; 
bk14.ZoneDist4=[];
bk14.AllZoning1=[];
bk14.AllZoning2=[];
bk14.BuiltCode=[];
bk14.Overlay1=[]; 
bk14.Overlay2=[]; 
bk14.SPDist1=[]; 
bk14.SPDist2=[]; 
bk14.LtdHeight=[]; 
bk14.SplitZone=[]; 
bk14.Easements=[]; 
bk14.OwnerType=[];
bk14.OwnerName=[]; 
bk14.AreaSource=[]; 
bk14.LotDepth=[]; 
bk14.BldgFront=[]; 
bk14.BldgDepth=[]; 
bk14.Ext=[]; 
bk14.ProxCode=[]; 
bk14.IrrLotCode=[]; 
bk14.BsmtCode=[]; 
bk14.BBL=[]; 
bk14.Tract2010=[]; 
bk14.ZoneMap=[]; 
bk14.ZMCode=[]; 
bk14.Sanborn=[]; 
bk14.TaxMap=[]; 
bk14.EDesigNum=[]; 
bk14.APPBBL=[]; 
bk14.APPDate=[]; 
bk14.PLUTOMapID=[]; 
bk14.Version=[];

%% add year
Year=repmat(2014,size(bk14,1),1);
bk14=[bk14 table(Year)];

%% historic/landmark flag
historicflag=zeros(size(bk14,1),1);
historicflag(ismissing(bk14.HistDist)==0)=1;
landmarkflag=zeros(size(bk14,1),1);
landmarkflag(ismissing(bk14.Landmark)==0)=1;
bk14.Landmark=[];
bk14.HistDist=[];
bk14=[bk14 table(historicflag) table(landmarkflag)];

%% Zoning District
% Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
% Commercial-4, Misc Commercial-5, Residential low density-6, Residential
% mid density-7, Residential high density-8, all other-9
% note most Neighborhood Retail exists in Residentially zoned districts
% with commercial overlays
Z=char(bk14.ZoneDist1);
Zoning=ones(size(bk14,1),1);
for i=1:size(bk14,1)
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

bk14.ZoneDist1=[];
bk14=[bk14 table(Zoning)];

%% Building Class
% One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
% Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
BC=char(bk14.BldgClass);
BuildingClass=ones(size(bk14,1),1);
for i=1:size(bk14,1)
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

bk14.BldgClass=[];
bk14=[bk14 table(BuildingClass)];
            
%% create value per square foot
% special treatment of condos and vacant land? 

ValPSF=bk14.AssessTot./bk14.BldgArea;
ValPSF(isnan(ValPSF)==1)=0;
ValPSF(isinf(ValPSF)==1)=0;
bk14=[bk14 table(ValPSF)];

%% drop rows with missing data
bk14=rmmissing(bk14);
%%
writetable(bk14,'bk14clean.csv')
