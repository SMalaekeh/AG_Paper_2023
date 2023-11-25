# Primary Works -------------------------------------------------1400/01/11

dev.off()
rm(list= ls())
library(readxl)
library(readr)
library(dplyr)
library(spdep)
library(rgdal)
library(sp)

# Sorting the D --------------------------------------------1400/01/24
#function to convert and sort
Sorter = function(mat, type = F,code){
  #First sort in row
  mat = as.data.frame(cbind(code,mat))
  mat = mat[order(mat$code,decreasing = type),]
  mat = as.matrix(mat[,2:ncol(mat)])
  mat = t(mat)  
  #then sort in col
  mat = as.data.frame(cbind(code,mat))
  mat = mat[order(mat$code,decreasing = type),]
  mat = t(mat)
  Sorted_Code = append(sort(code,decreasing = type),0,0)
  mat = cbind(Sorted_Code,mat)
  return(mat)
}

# Reading the Map -------------------------------------------1400/01/11
#Read the Shape file to Class SP
map = readOGR(dsn = "D:/Civil/Master/Ms.cTheses/Data/Ricardian/Shapefile", 
              layer = "Counties")   
#Transform and Project Other Datum = NAD83
map = spTransform(map, CRS("+proj=longlat +datum=WGS84"))   
#Convert Map to Data.Frame
map.df = as.data.frame(map)
#Calculating the Coordinates
coor = coordinates(map) 

# Contiguity Matrix -----------------------------------------1400/01/24
#Convert to Spatial Polygons 
map.sp = as(map, "SpatialPolygons")  
#Convert to NB class
cont.map.nb = poly2nb(map.sp, queen=T) 
#To check if it is Symmetric
is.symmetric.nb(cont.map.nb)  
#Creation of the Spatial Matrix Row-Standardized to 1 (Option W)
cont.listw = nb2listw(cont.map.nb, style="W",zero.policy = F)   
#Making the Cont Matrix
cont.mat = nb2mat(cont.map.nb, zero.policy = F,style = "W")   
#sorting the Dataset 
cont.mat = Sorter(cont.mat,type = F,map.df$Code) #Type = T means descending
#Plotting the Contiguity Map
plot(map,main = "Contiguity Matirx")
#Neighborly Layer
plot(cont.map.nb,coor,add=T,col = "red")  
#Saving the FINAL MATRIX
write.csv(cont.mat,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Weight_Matrix/Cont_Weight_W_Asc.csv")


# KNN Matrix --------------------------------------------------1400/01/31

#Centroid
coor = coordinates(map)   
#number of K
K = 5
#k = ? nearest neighbors 
knn = knearneigh(coor, k=K)
knn.nb = knn2nb(knn)
#plotting 
plot(map,main = "Knn Matirx")
plot(knn.nb,coor,add = T, col = "green")
#making it symmetry
knn.nb.sym = make.sym.nb(knn.nb)
is.symmetric.nb(knn.nb.sym)
#making the matrix
knn.mat = nb2mat(knn.nb.sym,style = "W")
#sorting the Dataset 
knn.mat.sorted = Sorter(knn.mat,type = T,map.df$Code) #Type = T means descending
#Saving the FINAL MATRIX
write.csv(knn.mat.sorted,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Weight_Matrix/KNN10_Weight_W_Dsc.csv")


# Distance Matrix -------------------------------------------1400/01/31

#Centroid
coor = coordinates(map)  
#setting the distance which every county contains at least one neighbor
kkk = knn2nb(knearneigh(coor))
all = max(unlist(nbdists(kkk,coor)))
dist = dnearneigh(coor,0,all)
#or setting by hand
distance = 100
dist = dnearneigh(coor, 0, distance, longlat = T)
#plotting
plot(map, main = "Contiguity Matirx")
plot(dist,coor,add = T, col = "yellow")
#converting to matrix
dist.mat = nb2mat(dist, style = "B", zero.policy = T)
#average in rows
AIR = colMeans(t(dist.mat))
#adding to shapefile
map$AIR = AIR
#plotting the mean vector
spplot(map,"AIR")
#sorting the Dataset 
dist.mat.sorted = Sorter(dist.mat,type = T,map.df$Code) #Type = T means descending
#Saving the FINAL MATRIX
write.csv(dist.mat.sorted,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Weight_Matrix/dist1_Weight_B_Dsc.csv")


# Inverse Matrix -------------------------------------------1400/01/31


#Centroid
coor = coordinates(map)  
#All neighbors!
knn.all = knearneigh(coor, k = 314)
knn.all.nb = knn2nb(knn.all)
dist = nbdists(knn.all.nb,coor)
#introducing the function
dist.function = lapply(dist, function(x) 1/x) 
inverse.dist.mat = nb2mat(knn.all.nb, glist = dist.function)
#sorting
inverse.dist.mat.sorted = Sorter(inverse.dist.mat,type = F,
                                 map.df$Code) #Type = T means descending
#Saving the FINAL MATRIX
write.csv(inverse.dist.mat.sorted,"D:/Civil/Master/Ms.cTheses/Data/Ricardian/Weight_Matrix/inverse_Weight_Asc.csv")




