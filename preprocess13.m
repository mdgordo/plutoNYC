%% delete extra variables
bk13.Borough=[];
bk13.Council=[]; 
bk13.FireComp=[]; 
bk13.PolicePrct=[]; 
bk13.Address=[]; 
bk13.ZoneDist2=[]; 
bk13.ZoneDist3=[]; 
bk13.ZoneDist4=[];
bk13.AllZoning1=[];
bk13.AllZoning2=[];
bk13.BuiltCode=[];
bk13.Overlay1=[]; 
bk13.Overlay2=[]; 
bk13.SPDist1=[]; 
bk13.SPDist2=[]; 
bk13.LtdHeight=[]; 
bk13.SplitZone=[]; 
bk13.Easements=[]; 
bk13.OwnerType=[];
bk13.OwnerName=[]; 
bk13.AreaSource=[]; 
bk13.LotDepth=[]; 
bk13.BldgFront=[]; 
bk13.BldgDepth=[]; 
bk13.Ext=[]; 
bk13.ProxCode=[]; 
bk13.IrrLotCode=[]; 
bk13.BsmtCode=[]; 
bk13.BBL=[]; 
bk13.Tract2010=[]; 
bk13.ZoneMap=[]; 
bk13.ZMCode=[]; 
bk13.Sanborn=[]; 
bk13.TaxMap=[]; 
bk13.EDesigNum=[]; 
bk13.APPBBL=[]; 
bk13.APPDate=[]; 
bk13.PLUTOMapID=[]; 
bk13.Version=[];

%% add year
Year=repmat(2013,size(bk13,1),1);
bk13=[bk13 table(Year)];

%% historic/landmark flag
historicflag=zeros(size(bk13,1),1);
historicflag(ismissing(bk13.HistDist)==0)=1;
landmarkflag=zeros(size(bk13,1),1);
landmarkflag(ismissing(bk13.Landmark)==0)=1;
bk13.Landmark=[];
bk13.HistDist=[];
bk13=[bk13 table(historicflag) table(landmarkflag)];

%% Zoning District
% Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
% Commercial-4, Misc Commercial-5, Residential low density-6, Residential
% mid density-7, Residential high density-8, all other-9
% note most Neighborhood Retail exists in Residentially zoned districts
% with commercial overlays
Z=char(bk13.ZoneDist1);
Zoning=ones(size(bk13,1),1);
for i=1:size(bk13,1)
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

bk13.ZoneDist1=[];
bk13=[bk13 table(Zoning)];

%% Building Class
% One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
% Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
BC=char(bk13.BldgClass);
BuildingClass=ones(size(bk13,1),1);
for i=1:size(bk13,1)
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

bk13.BldgClass=[];
bk13=[bk13 table(BuildingClass)];         

%% create value per square foot
% special treatment of condos and vacant land? 

ValPSF=bk13.AssessTot./bk13.BldgArea;
ValPSF(isnan(ValPSF)==1)=0;
ValPSF(isinf(ValPSF)==1)=0;
bk13=[bk13 table(ValPSF)];

%% drop rows with missing data
bk13=rmmissing(bk13);
%%
writetable(bk13,'bk13clean.csv')
