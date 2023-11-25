# Investigation of Economics Impact of Climate Change on Agriculture in Iran: Spatial Spillovers Matter

This GitHub repository hosts the code and data for the research paper titled "Investigation of the Economic Impact of Climate Change on Agriculture in Iran: Spatial Spillovers Matter."

All data, including processed climatic data from AgERA5, are available here except the agricultural data that are not publicly available or climatic data that are very large in size (CMIP6 outcomes) to be shared. These data are available upon request. 

The code scripts are written in MATLAB, STATA, and R. Note that you will need licenses for STATA and MATLAB to fully replicate the analysis. 

There are five stages to our analysis:

1. Extracting climatic variables from AgERA5 and aggregating to the county level. The MATLAB codes for this stage are “Code_NC_Iterator.m” and “Code_NC_AgrEra5.m”. The shape file used for this aggregation is available in data folder as “County.zip”. The raw data are downloaded from the Copernicus Climate Change Service (C3S) Climate Data Store: https://cds.climate.copernicus.eu/cdsapp#!/search?type=dataset. 

*Climate variables extracted from this stage are available in the Data folder. 

2.  The climatic variables extracted in the first stage are used to calculate extreme indices. The R code for this stage is “ClimateIndex.R”. 

*Climate indices extracted from this stage are available in the Data folder.

3. Climatic data and non-climatic data from Census and HIES are merged to make a tabular data which later be used in the STATA. There are many scripts for cleaning non-climatic variables in this stage that are not included. But the final script which is used to merge all columns from different cleaned datasets is “Merge_Ricardian.R”.

*The .dta file of the merged dataset (climatic and non-climatic variables) is included in the Data folder (“Ricardian_V9.dta). Note that some agricultural data are excluded in this dataset due to confidentiality.

3. In this stage, we run the spatial panel models and the impact Table in R and STATA. We first create the weighting matrices using R. The code for this is “Spatial_Weighting_Matrix.R”. 

*The output of some of the weighting matrices are included in the Data folder. 

The weighting matrices and .dta file are used as the inputs into the spatial panel models. The STATA codes for this stage are “Spatial_Panel_Ricardian_V3.do” and “Spatial_Panel_Ricardian_Robustness.do”.

4. In this stage, we forecast the climate change up to 2080 under several scenarios. The MATLAB code for this stage is “CMIP6_Models.m”. The raw data are downloaded from the Copernicus Climate Change Service (C3S) Climate Data Store: https://cds.climate.copernicus.eu/cdsapp#!/search?type=dataset. The predicted daily climatic variables are then used to predict climate indices as well using the same code as before “ClimateIndex.R”.

5. In this stage, we estimate the future impact of climate change on agriculture in Iran. The MATLAB codes for this stage are “Impacts.m” and “DX_Calculator.m”. 

*The final excel file of this step is included in the Data folder (“Impact_FinalResult_Ricardian.xlsx”).

Some additional scripts are included:
a) some descriptive analysis of agricultural data: “Agriculture_descriptive_statistics.R”.
b) the script to make correlation matrix of variables: “CorrelationMatrix.R”.

For inquiries regarding data and model used in this study or any other questions, please contact malaekeh@utexas.edu. 
