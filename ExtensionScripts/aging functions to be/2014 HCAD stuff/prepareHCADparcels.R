library(sf)
parcels <- st_read("Parcels.shp")

parcels$valid=st_is_valid(parcels, reason = TRUE)
validparcels=subset(parcels,parcels$valid=="Valid Geometry")

#Read in Texas Census Tract Files
TXCensusTracts <- st_read("../TexasCensusTractShapefiles/gz_2010_48_140_00_500k.shp")
#Put them in same CRS as Parcels
TXCensusTracts <- st_transform(TXCensusTracts,st_crs(validparcels))

#Get Census Tracts for each parcel
CensusTractforHCADParcels=st_within(validparcels,TXCensusTracts)
CensusTractforHCADParcelsunlisted=rapply(CensusTractforHCADParcels,function(x) ifelse(length(x)==0,9999999999999999999,x), how = "replace")
CensusTractforHCADParcelsunlisted=unlist(CensusTractforHCADParcelsunlisted)

validparcels$COUNTY=TXCensusTracts$COUNTY[CensusTractforHCADParcelsunlisted]
validparcels$TRACT=TXCensusTracts$TRACT[CensusTractforHCADParcelsunlisted]

#Save this thing because it takes a long time to load
saveRDS(validparcels,"validparcels.RDS")
#Merge with building features for residential houses

#Read in data
buildingfeatures=read.table('building_res.txt',sep="\t", header=FALSE, fill=TRUE,colClasses = "character",strip.white = TRUE,quote = "")#, ,colClasses = "character",stringsAsFactors = FALSE
#buildingfeatures=buildingfeatures[-(1:371770),]
colnames(buildingfeatures)=c("ACCOUNT", "USE_CODE", "BUILDING_NUMBER","IMPRV_TYPE","BUILDING_STYLE_CODE","CLASS_STRUCTURE","CLASS_STRUC_DESCRIPTION","DEPRECIATION_VALUE","CAMA_REPLACEMENT_COST","ACCRUED_DEPR_PCT","QUALITY","QUALITY_DESCRIPTION","DATE_ERECTED","EFFECTIVE_DATE","YR_REMODEL","YR_ROLL","APPRAISED_BY","APPRAISED_DATE","NOTE","IMPR_SQ_FT","ACTUAL_AREA","HEAT_AREA","GROSS_AREA","EFFECTIVE_AREA","BASE_AREA","PERIMETER","PERCENT_COMPLETE","NBHD_FACTOR","RCNLD","SIZE_INDEX","LUMP_SUM_ADJ")

#validparceldataframe=as.data.frame(validparcels)

#validparceldataframe2=merge(buildingfeatures,validparceldataframe,by.x="ACCOUNT",by.y="HCAD_NUM")

#Maybe this is better than that
library(tigris)
buildingfeatures$"HCAD_NUM"=buildingfeatures$ACCOUNT

validparcel2=geo_join(validparcels,buildingfeatures,by="HCAD_NUM",how="inner")

#Convert to data frame
validparceldataframe2=as.data.frame(validparcel2)
#validparceldataframe2=unlist(validparceldataframe2)
#Write to tab delimited file
#csv is a bad idea because of geometry column

saveRDS(validparceldataframe2,"validparceldataframe2.RDS")
saveRDS(validparcel2,"validparcelsforhouseholds.RDS")
#Write to tab delimited file

#So places where people may live in for group quarters I think are more likely to be in the commercial file
#then residential because it's commercial property-dorms, assisted living facilities etc

#So we need the non residential files
buildingfeatures=read.table('building_other.txt',sep="\t", header=FALSE, fill=TRUE,colClasses = "character",strip.white = TRUE,quote = "")#, ,colClasses = "character",stringsAsFactors = FALSE
colnames(buildingfeatures)=c("ACCOUNT", "USE_CODE", "BUILDING_NUMBER","IMPRV_TYPE","BUILDING_STYLE_CODE","CLASS_STRUCTURE","CLASS_STRUC_DESCRIPTION","NOTICED_DEPR_VALUE","DEPRECIATION_VALUE","MS_REPLACEMENT_COST","CAMA_REPLACEMENT_COST","ACCRUED_DEPR_PCT","QUALITY","QUALITY_DESCRIPTION","DATE_ERECTED","EFFECTIVE_DATE","YR_REMODEL","YR_ROLL","APPRAISED_BY","APPRAISED_DATE","NOTE","IMPR_SQ_FT","ACTUAL_AREA","HEAT_AREA","GROSS_AREA","EFFECTIVE_AREA","BASE_AREA","PERIMETER","PERCENT_COMPLETE","CATEGORY","CATEGORY_DESC","PROPERTY_NAME","UNITS","NET_RENT_AREA","LEASE_RATE","OCCUPANCY","TOTAL_INCOME")

buildingfeatures$"HCAD_NUM"=buildingfeatures$ACCOUNT

validparcels3=geo_join(validparcels,buildingfeatures,by="HCAD_NUM",how="inner")
saveRDS(validparcels3,"validparcelsforgroupquartersmaybe.RDS")
#Convert to data frame
validparceldataframe3=as.data.frame(validparcels3)
#validparceldataframe2=unlist(validparceldataframe2)
#Write to tab delimited file
#csv is a bad idea because of geometry column

saveRDS(validparceldataframe3,"validparceldataframe3forgroupquarters.RDS")

#Building Style Codes of Interest
#8351 Single Family Residence
#8150 Single Wide Commercial Home
#101 Residential 1 Family
#102 Residential 2 Family
#103 Residential 3 Family
#104 Residential 4 Family or More
#108 Single Wide Residential Mobile Home
#109 Double ide Reidential Mobile Home
#125 Farm with Dwelling
#8300 Apartment
#8321 Dormitory
#8324 Frat House
#8338 Loft
#8352 Multiple Res (Low Rise)
#8424 Group Care Home
#8451 Multiple Res (en. Citizen)
#8459 Mixed Retail with Resid. Units
#8587 Shell Multiple Res
#8589 Elderly Assist Multi Res
#8596 Shell, Apartment
#8710 Retirement Community Complex

#
vp1=readRDS("validparcelsforhouseholds.RDS")
vp2=readRDS("validparcelsforgroupquartersmaybe.RDS")
library(plyr)
fullvalidparcelsweneed=rbind.fill(vp1,vp2)
saveRDS(fullvalidparcelsweneed,"valid_parcels_for_simulation.RDS")
