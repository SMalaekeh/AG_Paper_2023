rm(list=ls())

#Reading Data
library(readr)
Temp_Max = read_csv("D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Temp_Hourly_Era5/2mTemp_Hourly_Max.csv")
Temp_Min = read_csv("D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Temp_Hourly_Era5/2mTemp_Hourly_Min.csv")
Prec = read_csv("D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Prec_AgrEra5/Precipitaion_Flux_Daily_1986_2015.csv")
unloadNamespace("readr")
Temp_Max = Temp_Max - 273.15
Temp_Min = Temp_Min - 273.15

#Reprocessing Data
Prec[333,2:ncol(Prec)] = Prec[326,2:ncol(Prec)]
source("D:/Civil/Master/Ms.cTheses/Results and Codes/Climate Indices/PRE.R")
Temp_Max = PRE(Temp_Max)
Temp_Min = PRE(Temp_Min)
Prec = PRE(Prec) ; rm(PRE)
Temp_Date = c(as.Date("1986-01-01"))
for (i in 1:(nrow(Temp_Max)-1)){
  Temp_Date = append(Temp_Date,Temp_Date[1]+i)
}
Temp_Date = as.character(Temp_Date)
Prec_Date = as.character(Temp_Date[1:nrow(Prec)])

#Climate Indice
library(climdex.pcic)
Prec_Date = as.PCICt(Prec_Date,cal = "gregorian")
Temp_Date = as.PCICt(Temp_Date,cal = "gregorian")

#CDD
CDD = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  CDD = cbind(CDD,climdex.cdd(Pr))
  print(i)
}
colnames(CDD) = colnames(Prec)
write.csv(CDD,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/CDD.csv"); rm(CDD); rm(Pr)

#CWD
CWD = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  CWD = cbind(CWD,climdex.cwd(Pr))
  print(i)
}
colnames(CWD) = colnames(Prec)
write.csv(CWD,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/CWD.csv"); rm(CWD); rm(Pr)

#PRCPTOT
PRCPTOT = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  PRCPTOT = cbind(PRCPTOT,climdex.prcptot(Pr))
  print(i)
}
colnames(PRCPTOT) = colnames(Prec)
write.csv(PRCPTOT,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/PRCPTOT.csv"); rm(PRCPTOT); rm(Pr)

#Rx1Day
Rx1Day_Monthly = c()
Rx1Day_Yearly = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  Rx1Day_Monthly = cbind(Rx1Day_Monthly,climdex.rx1day(Pr,freq="monthly"))
  Rx1Day_Yearly = cbind(Rx1Day_Yearly,climdex.rx1day(Pr,freq="annual"))
  print(i)
}
colnames(Rx1Day_Monthly) = colnames(Prec)
write.csv(Rx1Day_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/RX1Day_Monthly.csv"); rm(Rx1Day_Monthly); rm(Pr)
colnames(Rx1Day_Yearly) = colnames(Prec)
write.csv(Rx1Day_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/RX1Day_Yearly.csv"); rm(Rx1Day_Yearly);

#Rx5Day
Rx5Day_Monthly = c()
Rx5Day_Yearly = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  Rx5Day_Monthly = cbind(Rx5Day_Monthly,climdex.rx5day(Pr,freq="monthly"))
  Rx5Day_Yearly = cbind(Rx5Day_Yearly,climdex.rx5day(Pr,freq="annual"))
  print(i)
}
colnames(Rx5Day_Monthly) = colnames(Prec)
write.csv(Rx5Day_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/RX5Day_Monthly.csv"); rm(Rx5Day_Monthly); rm(Pr)
colnames(Rx5Day_Yearly) = colnames(Prec)
write.csv(Rx5Day_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/RX5Day_Yearly.csv"); rm(Rx5Day_Yearly)

#SDII
SDII = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  SDII = cbind(SDII,climdex.sdii(Pr))
  print(i)
}
colnames(SDII) = colnames(Prec)
write.csv(SDII,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/SDII.csv"); rm(SDII); rm(Pr)

#R10mm
R10mm = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  R10mm = cbind(R10mm,climdex.r10mm(Pr))
  print(i)
}
colnames(R10mm) = colnames(Prec)
write.csv(R10mm,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/R10mm.csv"); rm(R10mm); rm(Pr)

#R20mm
R20mm = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  R20mm = cbind(R20mm,climdex.r20mm(Pr))
  print(i)
}
colnames(R20mm) = colnames(Prec)
write.csv(R20mm,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/R20mm.csv"); rm(R20mm); rm(Pr)

#Rnnmm
Rnnmm = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  Rnnmm = cbind(Rnnmm,climdex.rnnmm(Pr,threshold = 50))
  print(i)
}
colnames(Rnnmm) = colnames(Prec)
write.csv(Rnnmm,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/R50mm.csv"); rm(Rnnmm); rm(Pr)

#R95ptot
R95ptot = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  R95ptot = cbind(R95ptot,climdex.r95ptot(Pr))
  print(i)
}
colnames(R95ptot) = colnames(Prec)
write.csv(R95ptot,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/R95ptot.csv"); rm(R95ptot); rm(Pr)

#R99ptot
R99ptot = c()
for (i in 1:ncol(Prec)){
  Pr = climdexInput.raw(prec=Prec[,i],prec.dates = Prec_Date,base.range = c(1986,2014))
  R99ptot = cbind(R99ptot,climdex.r99ptot(Pr))
  print(i)
}
colnames(R99ptot) = colnames(Prec)
write.csv(R99ptot,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/R99ptot.csv"); rm(R99ptot); rm(Pr)

#FD
FD = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  FD = cbind(FD,climdex.fd(Te))
  print(i)
}
colnames(FD) = colnames(Temp_Max)
write.csv(FD,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/FD.csv"); rm(FD); rm(Te)

#SU
SU = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  SU = cbind(SU,climdex.su(Te))
  print(i)
}
colnames(SU) = colnames(Temp_Max)
write.csv(SU,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/SU.csv"); rm(SU); rm(Te)

#ID
ID = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  ID = cbind(ID,climdex.id(Te))
  print(i)
}
colnames(ID) = colnames(Temp_Max)
write.csv(ID,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/ID.csv"); rm(ID); rm(Te)

#TR
TR = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TR = cbind(TR,climdex.tr(Te))
  print(i)
}
colnames(TR) = colnames(Temp_Max)
write.csv(TR,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TR.csv"); rm(TR); rm(Te)

#GSL
GSL = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  GSL = cbind(GSL,climdex.gsl(Te))
  print(i)
}
colnames(GSL) = colnames(Temp_Max)
write.csv(GSL,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/GSL.csv"); rm(GSL); rm(Te)

#TXX
TXX_Monthly = c()
TXX_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TXX_Monthly = cbind(TXX_Monthly,climdex.txx(Te,freq = "monthly"))
  TXX_Yearly = cbind(TXX_Yearly,climdex.txx(Te,freq = "annual"))
  print(i)
}
colnames(TXX_Monthly) = colnames(Temp_Max)
write.csv(TXX_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TXX_Monthly.csv"); rm(TXX_Monthly); rm(Te)
colnames(TXX_Yearly) = colnames(Temp_Max)
write.csv(TXX_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TXX_Yearly.csv"); rm(TXX_Yearly)

#TNX
TNX_Monthly = c()
TNX_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TNX_Monthly = cbind(TNX_Monthly,climdex.tnx(Te,freq = "monthly"))
  TNX_Yearly = cbind(TNX_Yearly,climdex.tnx(Te,freq = "annual"))
  print(i)
}
colnames(TNX_Monthly) = colnames(Temp_Max)
write.csv(TNX_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TNX_Monthly.csv"); rm(TNX_Monthly); rm(Te)
colnames(TNX_Yearly) = colnames(Temp_Max)
write.csv(TNX_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TNX_Yearly.csv"); rm(TNX_Yearly)

#TNN
TNN_Monthly = c()
TNN_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TNN_Monthly = cbind(TNN_Monthly,climdex.tnn(Te,freq = "monthly"))
  TNN_Yearly = cbind(TNN_Yearly,climdex.tnn(Te,freq = "annual"))
  print(i)
}
colnames(TNN_Monthly) = colnames(Temp_Max)
write.csv(TNN_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TNN_Monthly.csv"); rm(TNN_Monthly); rm(Te)
colnames(TNN_Yearly) = colnames(Temp_Max)
write.csv(TNN_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TNN_Yearly.csv"); rm(TNN_Yearly)

#TXN
TXN_Monthly = c()
TXN_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TXN_Monthly = cbind(TXN_Monthly,climdex.txn(Te,freq = "monthly"))
  TXN_Yearly = cbind(TXN_Yearly,climdex.txn(Te,freq = "annual"))
  print(i)
}
colnames(TXN_Monthly) = colnames(Temp_Max)
write.csv(TXN_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TXN_Monthly.csv"); rm(TXN_Monthly); rm(Te)
colnames(TXN_Yearly) = colnames(Temp_Max)
write.csv(TXN_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TXN_Yearly.csv"); rm(TXN_Yearly)

#TN10p
TN10p_Monthly = c()
TN10p_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TN10p_Monthly = cbind(TN10p_Monthly,climdex.tn10p(Te,freq = "monthly"))
  TN10p_Yearly = cbind(TN10p_Yearly,climdex.tn10p(Te,freq = "annual"))
  print(i)
}
colnames(TN10p_Monthly) = colnames(Temp_Max)
write.csv(TN10p_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TN10p_Monthly.csv"); rm(TN10p_Monthly); rm(Te)
colnames(TN10p_Yearly) = colnames(Temp_Max)
write.csv(TN10p_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TN10p_Yearly.csv"); rm(TN10p_Yearly)

#TN90p
TN90p_Monthly = c()
TN90p_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TN90p_Monthly = cbind(TN90p_Monthly,climdex.tn90p(Te,freq = "monthly"))
  TN90p_Yearly = cbind(TN90p_Yearly,climdex.tn90p(Te,freq = "annual"))
  print(i)
}
colnames(TN90p_Monthly) = colnames(Temp_Max)
write.csv(TN90p_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TN90p_Monthly.csv"); rm(TN90p_Monthly); rm(Te)
colnames(TN90p_Yearly) = colnames(Temp_Max)
write.csv(TN90p_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TN90p_Yearly.csv"); rm(TN90p_Yearly)

#TX10p
TX10p_Monthly = c()
TX10p_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TX10p_Monthly = cbind(TX10p_Monthly,climdex.tx10p(Te,freq = "monthly"))
  TX10p_Yearly = cbind(TX10p_Yearly,climdex.tx10p(Te,freq = "annual"))
  print(i)
}
colnames(TX10p_Monthly) = colnames(Temp_Max)
write.csv(TX10p_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TX10p_Monthly.csv"); rm(TX10p_Monthly); rm(Te)
colnames(TX10p_Yearly) = colnames(Temp_Max)
write.csv(TX10p_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TX10p_Yearly.csv"); rm(TX10p_Yearly)

#TX90p
TX90p_Monthly = c()
TX90p_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  TX90p_Monthly = cbind(TX90p_Monthly,climdex.tx90p(Te,freq = "monthly"))
  TX90p_Yearly = cbind(TX90p_Yearly,climdex.tx90p(Te,freq = "annual"))
  print(i)
}
colnames(TX90p_Monthly) = colnames(Temp_Max)
write.csv(TX90p_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TX90p_Monthly.csv"); rm(TX90p_Monthly); rm(Te)
colnames(TX90p_Yearly) = colnames(Temp_Max)
write.csv(TX90p_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/TX90p_Yearly.csv"); rm(TX90p_Yearly)

#WSDI
WSDI = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  WSDI = cbind(WSDI,climdex.wsdi(Te))
  print(i)
}
colnames(WSDI) = colnames(Temp_Max)
write.csv(WSDI,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/WSDI.csv"); rm(WSDI); rm(Te)

#CSDI
CSDI = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  CSDI = cbind(CSDI,climdex.csdi(Te))
  print(i)
}
colnames(CSDI) = colnames(Temp_Max)
write.csv(CSDI,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/CSDI.csv"); rm(CSDI); rm(Te)

#dtr
dtr_Monthly = c()
dtr_Yearly = c()
for (i in 1:ncol(Temp_Max)){
  Te = climdexInput.raw(tmax = Temp_Max[,i],tmin = Temp_Min[,i],tmax.dates = Temp_Date,tmin.dates = Temp_Date,base.range = c(1986,2015))
  dtr_Monthly = cbind(dtr_Monthly,climdex.dtr(Te,freq = "monthly"))
  dtr_Yearly = cbind(dtr_Yearly,climdex.dtr(Te,freq = "annual"))
  print(i)
}
colnames(dtr_Monthly) = colnames(Temp_Max)
write.csv(dtr_Monthly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/dtr_Monthly.csv"); rm(dtr_Monthly); rm(Te)
colnames(dtr_Yearly) = colnames(Temp_Max)
write.csv(dtr_Yearly,"D:/Civil/Master/Ms.cTheses/Data/Climate/Climate_Panel/Climate Indices Codes/CSV/CSV_Climdex/dtr_Yearly.csv"); rm(dtr_Yearly)
