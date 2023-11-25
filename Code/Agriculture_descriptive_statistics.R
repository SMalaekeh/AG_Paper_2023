##### This code was written to provide some descriptive statistics about the 
##### agricultural area and profit for the three years
# Primary works -----------------------------------------------------1400/04/22

rm(list= ls())
library(readxl)
library(readr)
library(dplyr)
#Ricardian data
ric = read_csv("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian_V9.csv")
#agricultural Jahad
Jahad = read_xlsx("D:/Civil/Master/Ms.cTheses/Data/Agriculture/zeraei/zeraei-61-95-shahrestani.xlsx")
#cleaning and setting name for columns
Jahad = Jahad[3:nrow(Jahad),]
colnames(Jahad) = c("Year","Pre-Year","State_Name","Code","State_Code",
                    "County_Code","Crop_Name","Crop_Code","Area_Abi",
                    "Area_Deym","Area_Tot","Product_Abi","Product_Deym",
                    "Product_Tot","Eff_Abi","Eff_Deym")
#agricultural states
Jahad = read_xlsx("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Agriculture Stats/LandUse_Agriculture.xlsx",sheet = "Slopes_Provincial")


# Summarizing -------------------------------------------------------------
ric = ric %>% filter(GDD34>5)
ric_g = ric[,c(1,2,68:117)] %>% group_by(Time) %>% summarise_if(is.numeric,sum,na.rm=T)

# Profit
Prof = read_xlsx("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian_V9_Profit.xlsx")
t = c(1,2,3)
slope = c()
for (i in 1:315){
  b = Prof[i,4:6]
  b = as.double(b)
  slope = append(slope,lm(b~t)[[1]][2])
}

# Jahad Kol--------------------------------------------------------------------
##### 1400/10/01 to calculate the slope of different types of crops

#   *********   seeing the trend in the whole country     ********

Jahad_Tot = Jahad %>% filter(State_Code == 99)
#trend in specific types of crops
iran_trend = list()
#crop types = "Ghalat" - "Hoboobat" - "Sanati" - "Sabzijat" - "Jaliz" - "Oloofe" - "Kol"
crop_types = c(117,131,155,171,185,197,199)
j = 0;
for (i in crop_types){
  j = j+1;
  print(i);
  jahad_dummy = Jahad_Tot %>% filter(Crop_Code==i)
  dummy = cbind(jahad_dummy$Year,jahad_dummy$Area_Abi,jahad_dummy$Area_Deym)
  dummy = list(dummy)
  iran_trend = append(iran_trend,dummy)
}
iran_trend_mat = matrix(nrow = 34,ncol=1,NA)
for (i in 1:7){
  dummy = iran_trend[[i]] 
  iran_trend_mat = cbind(iran_trend_mat,dummy[,2:3])
}
iran_trend_mat[,1] = dummy[,1]
write.csv(iran_trend_mat,"total_landuse_agriculture.csv")

#   *********   calculating the trend in the whole country     ********
#calculating the slope of each variables
Jahad_Tot = read_xlsx("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Agriculture Stats/total_landuse_agriculture.xlsx")
slopes = c()
time = 1982:2015
for (i in 2:16){
  dummy = unlist(Jahad_Tot[,i])
  slopes = append(slopes,lm(dummy~time)[[1]][2])
}
write.csv(slopes,"Jahad_Tot_Slopes.csv")  



# Jahad Per state --------------------------------------------------------
#trend analysis of corn in each province #1400/10/04
#filtering for only provincial data 
Jahad_St = Jahad %>% filter(County_Code == 0) %>% filter(State_Code!=99) %>%
  filter(Crop_Code == 197)
states = unique(as.array((Jahad_St$State_Code)))
slopes = c()
mean = c()
#33 provinces
for (i in states){
  dum = Jahad_St %>% filter(State_Code==i)
  time = 1:nrow(dum)
  slopes = append(slopes,lm(dum$Area_Deym~time)[[1]][2])
  mean = append(mean,mean(as.numeric(dum$Area_Abi)))
}
final = cbind(states,mean,slopes)  
write.csv(final,"oloofe_Deym_trend.csv")

# *************** Regression Analysis
#the correlation of temperature and agricultural land-use

