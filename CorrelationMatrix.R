# Making the Correlation Matrix -------------------------------------1400/01/24
library(readxl)
library(plyr)
library(dplyr)
#Reading the Data
Ricardian <- read_xlsx("D:/Civil/Master/Ms.cTheses/Data/Ricardian/Ricardian_V4.xlsx")
#Dropping the Non-Numeric Variables
Ric_Numeric = Ricardian[,4:66]
#Calculating The Mean
Corr = cor(Ric_Numeric,method = "kendall")
#Demeaning the Ricardian
Demean = numcolwise(function(x) x-mean(x))
#Adding the Codes
Ric_Numeric = cbind(Ricardian$Code,Ric_Numeric);colnames(Ric_Numeric)[1] = "Code"
#Grouping by Code
Ric_Num_Group = Ric_Numeric %>% group_by(Code)
#Applying the function to the Data Frame
Ric_Num_Demeaned = ddply(Ric_Num_Group,.(Code),Demean)
#Dropping the Code
Ric_Num_Demeaned = Ric_Num_Demeaned[,2:64]
#Calculating the Demeaned Corr
Corr_Demeaned = cor(Ric_Num_Demeaned,method = "kendall")
#Exporting the Data
write.csv(Corr,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Kendall_Corr.csv")
write.csv(Corr_Demeaned,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Demeaned_Kendall_Corr.csv")
