% %% delete extra variables
 bk15.Borough=[];
 bk15.Council=[]; 
 bk15.FireComp=[]; 
 bk15.PolicePrct=[]; 
 bk15.HealthArea=[]; 
 bk15.Address=[]; 
 bk15.ZoneDist2=[]; 
 bk15.ZoneDist3=[]; 
 bk15.ZoneDist4=[];
 bk15.AllZoning1=[];
 bk15.AllZoning2=[];
 bk15.BuiltCode=[];
 bk15.Overlay1=[]; 
 bk15.Overlay2=[]; 
 bk15.SPDist1=[]; 
 bk15.SPDist2=[]; 
 bk15.LtdHeight=[]; 
 bk15.SplitZone=[]; 
 bk15.Easements=[]; 
 bk15.OwnerType=[];
 bk15.OwnerName=[]; 
 bk15.AreaSource=[]; 
 bk15.LotDepth=[]; 
 bk15.BldgFront=[]; 
 bk15.BldgDepth=[]; 
 bk15.Ext=[]; 
 bk15.ProxCode=[]; 
 bk15.IrrLotCode=[]; 
 bk15.BsmtCode=[]; 
 bk15.BBL=[]; 
 bk15.Tract2010=[]; 
 bk15.ZoneMap=[]; 
 bk15.ZMCode=[]; 
 bk15.Sanborn=[]; 
 bk15.TaxMap=[]; 
 bk15.EDesigNum=[]; 
 bk15.APPBBL=[]; 
 bk15.APPDate=[]; 
 bk15.PLUTOMapID=[]; 
 bk15.Version=[];
 
 %% add year
 Year=repmat(2015,size(bk15,1),1);
 bk15=[bk15 table(Year)];
 
 %% historic/landmark flag
 historicflag=zeros(size(bk15,1),1);
 historicflag(ismissing(bk15.HistDist)==0)=1;
 landmarkflag=zeros(size(bk15,1),1);
 landmarkflag(ismissing(bk15.Landmark)==0)=1;
 bk15.Landmark=[];
 bk15.HistDist=[];
 bk15=[bk15 table(historicflag) table(landmarkflag)];
 
 %% Zoning District
 % Manufacturing-1, Neighborhood Retail-2, Destination Retail-3, Dense
 % Commercial-4, Misc Commercial-5, Residential low density-6, Residential
 % mid density-7, Residential high density-8, all other-9
 % note most Neighborhood Retail exists in Residentially zoned districts
 % with commercial overlays
 Z=char(bk15.ZoneDist1);
 Zoning=ones(size(bk15,1),1);
 for i=1:size(bk15,1)
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
 
 bk15.ZoneDist1=[];
 bk15=[bk15 table(Zoning)];
 
 %% Building Class
 % One and two family-1, Multifamily/mixed use-2, Condos-3, Industrial-4,
 % Retail-5, Hotel-6, Community/Health-7, Office-8, Vacant-9, Public/Other-10
 BC=char(bk15.BldgClass);
 BuildingClass=ones(size(bk15,1),1);
 for i=1:size(bk15,1)
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
 
 bk15.BldgClass=[];
 bk15=[bk15 table(BuildingClass)];
             
 %% create value per square foot
    % special treatment of condos and vacant land? 
 
ValPSF=(bk16.AssessTot-bk16.AssessLand)./bk16.BldgArea;
 ValPSF(isnan(ValPSF)==1)=0;
 ValPSF(isinf(ValPSF)==1)=0;
 bk15=[bk15 table(ValPSF)];
 
 %% drop rows with missing data
 bk15=rmmissing(bk15);
 %%
 writetable(bk15,'bk15clean.csv')
