# Primary Works -------------------------------------------------------03/12/1399
dev.off()
rm(list= ls())
library(readxl)
library(readr)
library(dplyr)
library(DescTools)
# Profit
Profit <- read_excel("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Profit/Profit.xlsx") 
# Ricardian
Ricardian <- read_xlsx("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian_V4.xlsx") 
BASE_DIR = getwd()


# Climate Data ------------------------------------------------------------
# Date
First_Month = as.Date("1986-01-01")
Date = First_Month
for (i in 1:360){
  Date = append(Date,AddMonths(First_Month,i))
}

# Making a panel data from a matrix
PanelMaker = function(X){
  Code = unlist(rep(X[,1],3)) # Repeating the Codes for each Time
  Panel = Code
  Time = append(rep(2006,315),rep(2010,315))
  Time = append(Time,rep(2014,315))
  Var = append(X[,2],X[,3])
  Var = append(Var,X[,4])
  Panel = cbind(Panel,Time,Var)
  return(Panel)
}


# Reading one by one Variables-----------------------------------------------

setwd("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Climate Variables")  # Changing the Directory
DIR = dir()   # All csv Files in the directory
N = length(DIR)   # Number of csv Files

for (i in 1:N){
  Name = DIR[i]
  Variable = read_csv(Name,col_names = FALSE)
  Code = Variable[,1]
  # Variables TYPE I
  Per_1 = apply(Variable[,62:313],1,mean)   
  Per_2 = apply(Variable[,110:361],1,mean)
  Per_3 = apply(Variable[,158:409],1,mean)
  # Variables TYPE II
  Per_1 = apply(Variable[,2:253],1,mean)   
  Per_2 = apply(Variable[,50:301],1,mean)
  Per_3 = apply(Variable[,98:ncol(Variable)],1,mean)
  # Binding Them
  X = cbind(Code,Per_1,Per_2,Per_3)
  # Make it a Panel 
  Panel = PanelMaker(X)
  colnames(Panel) = c("Code","Time","Tx")
  Panel = as.data.frame(Panel)
  Ricardian = inner_join(Ricardian,Panel,by=c("Code","Time"))
}

setwd(BASE_DIR)   # Return to the Base DIR
write.csv(Ricardian,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian.csv")


# Reading one by one Indices ----------------------------------------------

setwd("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Climate Indices/Yearly")  # Changing the Directory
DIR = dir()   # All csv Files in the directory
N = length(DIR)   # Number of csv Files

for (i in 1:N){
  Name = DIR[i]
  Variable = read_csv(Name,col_names = FALSE)
  Code = Variable[,1]
  # Variables TYPE I
  Per_1 = apply(Variable[,2:23],1,mean)   
  Per_2 = apply(Variable[,6:27],1,mean)
  Per_3 = apply(Variable[,10:ncol(Variable)],1,mean)
  # Binding Them
  X = cbind(Code,Per_1,Per_2,Per_3)
  # Make it a Panel 
  Panel = PanelMaker(X)
  Name = gsub("85.csv","",Name)
  colnames(Panel) = c("Code","Time",Name)
  Panel = as.data.frame(Panel)
  Ricardian = inner_join(Ricardian,Panel,by=c("Code","Time"))
}

setwd(BASE_DIR)   # Return to the Base DIR
write.csv(Ricardian,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian222.csv")



# HIES ------------------------------------------------------------1399/12/16
# Base Ricardian
Ricardian <- read_csv("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian.csv")
# HIES Data
Sum85 = read_csv("D:/Civil/Master/Ms.cTheses/Data/Ricardian/HIES/Sum85_Result.csv")
Sum89 = read_csv("D:/Civil/Master/Ms.cTheses/Data/Ricardian/HIES/Sum89_Result.csv")
Sum93 = read_csv("D:/Civil/Master/Ms.cTheses/Data/Ricardian/HIES/Sum93_Result.csv")
# Choosing the Attributes
Sum85 = subset(Sum85,select = -c(County_HIES,Weight_Sum,Weight_Sd))
Sum89 = subset(Sum89,select = -c(County_HIES,Weight_Sum,Weight_Sd))
Sum93 = subset(Sum93,select = -c(County_HIES,Weight_Sum,Weight_Sd))
# Converting Toman to M-Toman With Using the Deflator
MToman = function(X,Def){
  # Deflator
  A = c(49.2,100,214.5)
  Y = X[,3:7]/1000000/A[Def]*100
  X = cbind(X[,1:2],Y,X[,8:ncol(X)])
}
Sum85 = MToman(Sum85,1)
Sum89 = MToman(Sum89,2)
Sum93 = MToman(Sum93,3)

# Binding the HIES
Sum_Tot = rbind(Sum85,Sum89,Sum93)
# Joining the HIES and Ricardian
Ricardian = left_join(Ricardian,Sum_Tot,by=c("Code","Time"))


# Adding the State Column -------------------------------------------1399/12/18
Ricardian <- read_csv("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian.csv")
# Reading the County Code
codes = Ricardian$Code

# A function to extract the state from county code
State_Extractor = function(X){
  # Number of Digits
  l = floor(log10(X)) + 1
  if(l==1 | l==2){
    state = 0
  
    }else if(l==3){
    state = as.numeric(unlist(strsplit(as.character(X) , ""))[1])
  
    }else{
    state = unlist(strsplit(as.character(X) , ""))[1:2]
    state = as.numeric(paste(state[1],state[2],sep=""))
    }
  return(state)
}

# Applying the function to the codes
states = sapply(codes, State_Extractor)
# Joining the State
Ricardian$State = states
# Relocating the State Column
Ricardian = relocate(Ricardian,State, .before = Profit_Ori)


# Census Adding Extra POP -----------------------------------------1400/01/01
Census_Adder = function(Census){
  # R cant read Farsi so I add another variable
  Census$ID = Census %>% group_by(State) %>% group_indices(State)
  
  # Counties that are not in Shapefile
  cen_extra = distinct(Census %>% filter(Code%%100 == 0) %>% group_by(ID) %>%
    summarize(Pop = sum(Pop),ID=ID))
  
  # Counties that are in Shapefile
  cen_main = Census %>% filter(!Code%%100 == 0) %>%
    select(c("Code","Census_Code","ID",
             "County","Pop","Household","Pop","Pop_Men"))
  # Adding the Gender Percentages
  cen_main$Gender_Prob = cen_main$Pop_Men/cen_main$Pop
  
  # Adding extra population to the states
  Dummy = matrix(0,1,2)
  for (i in 1:nrow(cen_extra)){
    X = cen_extra[i,]
    cen_main_part = cen_main %>% filter(ID == X$ID)
    POP_old = as.numeric(cen_main_part %>% summarise(pop = sum(Pop)))
    POP_new = as.numeric(X["Pop"])                 
    deflator = (POP_old + POP_new) / POP_old
    cen_main_part$Pop_New = cen_main_part$Pop * deflator
    cen_main_part = cen_main_part %>% select(Pop_New,Code)
    colnames(Dummy) = colnames(cen_main_part)
    Dummy = rbind(Dummy,cen_main_part)
  }
  cen_main = left_join(cen_main,Dummy,by="Code")
  cen_main = cen_main %>% mutate(Pop = if_else(!is.na(Pop_New),Pop_New,Pop))
  return(cen_main)
}
# Census Joining ----------------------------------------------1400/01/01
# First I ran the previous section then this section works
# Reading the Data 
census85 <- read_excel("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Census/Cleaned_Census_Coded_1385.xlsx") s
census90 <- read_excel("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Census/Cleaned_Census_Coded_1390.xlsx") 
census95 <- read_excel("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Census/Cleaned_Census_Coded_1395.xlsx") 
# Calling a function to Add other counties
census85_new = Census_Adder(census85) ;rm(census85)
census90_new = Census_Adder(census90) ;rm(census90)
census95_new = Census_Adder(census95) ;rm(census95)

# Reading the ShapeFile CODES
Profit <- read_excel("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Profit/Profit.xlsx")
CODES = as.data.frame(unique(Profit$Code))
colnames(CODES) = "Code"

# Checking their County Code
CODES = left_join(CODES,census85_new,by = "Code")
CODES = left_join(CODES,census90_new,by = "Code")
CODES = left_join(CODES,census95_new,by = "Code")   

# Saving the CENSUS Data 85 90 95
write.csv(CODES,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Census_Final.csv")


# Koppen Classification -------------------------------------------1400/01/06
# Adding the Koppen Climate Classification to Ricardian
# Package
library(rgdal)
library(kgc)

# Reading the Shp
Map = readOGR(dsn = "D:/Civil/Master/Ms.cTheses/Data/Ricardian/Shapefile", 
              layer = "Counties")   
# Transform and Project Other Datum = NAD83
Map = spTransform(Map, CRS("+proj=longlat +datum=WGS84"))   
# Convert Map to Data.Frame
Map.df = as.data.frame(Map)

# Centroid
Coor = coordinates(Map)   
# Names
colnames(Coor) = c("Lon","Lat")

# Binding the Centroids and Codes
Map.df = cbind(Map.df,Coor) # It should be sorted afterwards
# Delete Extras
Coor = Map.df[c("Code","Lon","Lat")]

# Koppen
Coor = data.frame(Coor,rndCoord.lon = RoundCoordinates(Coor$Lon),rndCoord.lat = RoundCoordinates(Coor$Lat))
Coor = data.frame(Coor,ClimateZ=LookupCZ(Coor))
Coor = data.frame(Coor, CZUncertainty(Coor))
# Selecting
Coor = Coor[c("Code","ClimateZ","Lon","Lat")]

# Joining
Ricardian = left_join(Ricardian,Coor,by = "Code")
write_csv(Ricardian,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian_V4.csv")


# Extracting the Main Climates -----------------------------------1400/01/21
#Extracting the First Letter of the ClimateZ
Clim = Ricardian$ClimateZ
Main = function(X){
  unlist(strsplit(X , ""))[1]
}
MainClim = unlist(lapply(Clim, Main))
#Binding the MainClim Column
Ricardian = cbind(Ricardian,MainClim)
write_csv(Ricardian,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian_V5.csv")




