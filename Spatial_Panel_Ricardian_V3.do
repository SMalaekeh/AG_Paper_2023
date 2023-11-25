//////////////// This is code written in 1400/04/24 by SayedMorteza Malaekeh
//////////////// To estimate several spatial panel models 
//////////////// This code is part of the paper "Investigation of the Economics Impact of Climate Change on Agriculture in Iran: Spatial Spillovers Matter"
*************************** Deflating the Dependent Variable
program define deflator
	sort time code
	gen profit_new = prof_tot_ostani * 49.2/100 in 1/315
	replace profit_new = prof_tot_ostani in 316/630
	replace profit_new = prof_tot_ostani *214.5/100 in 631/945
	order profit_new , after(prof_tot_ostani)
	sort code time
	gen lnp_new = log(profit_new)
	order lnp_new, after(lnp)
end

**************************** Weighting Matrix
program define Weight
	drop v1
	drop in 1
	//Renaming the Variables
	rename v(#) m(#)
	rename v(##) m(##)
	rename v(###) m(###)
end
// Inverse Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\inverse_Weight_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Inverse m*
// Dist1 Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\dist1_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Dist1 m*
// KNN5 Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\KNN5_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_KNN5 m*
// Contiguity Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\Cont_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Cont m*

// Contiguity Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\Cont_Weight_W_Ds.csv", encoding(Big5) clear
Weight
spmat dta W_Cont_D m*


**************************** providing and manipulating the dataset 
// reading the data
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Ricardian_V9.csv", clear
// panel setup
sort code time
xtset code time, delta(5)
// Generating the Logarithm/Root
gen lnp = log(prof_tot_ostani)
gen root_gdd34 = sqrt(gdd34)
gen logdensity = log(density)
gen gdd8_squared = gdd8^2/1000
gen logdensity_squared = logdensity^2
gen pr_g_squared = pr_g ^2
gen pr_ng_squared = pr_ng ^2
gen pr_t_squared = pr_t ^2/1000
// Changing the Scale of Solar Radiation (To Million)
replace sr = sr/1000000
// Y LISTS
global ylist lnp
// deflating the dependent variable
deflator
// Irrigated or Rainfed
gen AD_Percent = (a102 + a104 + a108 + a118 + a122 + a132 + a146 + a148 + a156 + a158 + a160 + a174 + a176) /  (d102 + d104 + d118 + d122 + d146 + d148 + d160 + d174 + t106 + t138 + a102 + a104 + a108 + a118 + a122 + a132 + a146 + a148 + a156 + a158 + a160 + a174 + a176)
replace AD = 1 if AD==. in 1/945
// Dummy for Irrigated or Rainfed
gen AD_30_Dummy = 0
replace AD_30_Dummy = 1 if AD_Percent >=0.30
// Dummy for Irrigated or Rainfed 
gen AD_50_Dummy = 0
replace AD_50_Dummy = 1 if AD_Percent >=0.50
// Two seasons precipitation
gen pr_first2 = pr_fal + pr_win
gen pr_second2 = pr_sum + pr_spr
// defining best Xs
global BESTX gdd8 gdd8_squared root_gdd34 pr_t pr_t_squared cdd ncost logdensity id sdii gsl literacy_prob AD_Percent 
global BESTX1 gdd8 gdd8_squared root_gdd34 pr_t pr_t_squared cdd ncost logdensity id sdii gsl literacy_prob AD_30_Dummy
global BESTX2 gdd8 gdd8_squared root_gdd34 pr_t pr_t_squared cdd ncost logdensity id sdii gsl literacy_prob AD_50_Dummy
global BESTX3 gdd8 gdd8_squared root_gdd34 pr_t cdd ncost logdensity id sdii gsl literacy_prob AD_Percent 
global BESTX4 gdd8 gdd8_squared gdd30 root_gdd34 pr_t ncost logdensity csdi sdii gsl literacy_prob AD_Percent 



*********************************** Final Paper Models
//Panel
xtreg lnp_new $BESTX4, fe 
estimates store nonsp_Panel
xtreg lnp_new $BESTX4 i.time, fe 
estimates store nonsp_panel_time

//SAR Model 
xsmle lnp_new $BESTX4, wmat(W_Cont) model(sar) fe type(ind, leeyu)
estimates store sp_panel_cont_ind
xsmle lnp_new $BESTX4, wmat(W_Cont) model(sar) fe type(both, leeyu)
estimates store sp_panel_cont_both

xsmle lnp_new $BESTX4, wmat(W_KNN5) model(sar) fe type(ind, leeyu)
estimates store sp_panel_knn5_ind
xsmle lnp_new $BESTX4, wmat(W_KNN5) model(sar) fe type(both, leeyu)
estimates store sp_panel_knn5_both

xsmle lnp_new $BESTX4, wmat(W_Dist1) model(sar) fe type(ind, leeyu)
estimates store sp_panel_Dist1_ind
xsmle lnp_new $BESTX4, wmat(W_Dist1) model(sar) fe type(both, leeyu)
estimates store sp_panel_Dist1_both


//SEM Model
xsmle lnp_new $BESTX4, emat(W_Cont) model(sem) fe type(ind, leeyu)
estimates store spe_panel_cont_ind
xsmle lnp_new $BESTX4, emat(W_Cont) model(sem) fe type(both, leeyu)
estimates store spe_panel_cont_both

xsmle lnp_new $BESTX4, emat(W_KNN5) model(sem) fe type(ind, leeyu)
estimates store spe_panel_knn5_ind
xsmle lnp_new $BESTX4, emat(W_KNN5) model(sem) fe type(both, leeyu)
estimates store spe_panel_knn5_both

xsmle lnp_new $BESTX4, emat(W_Dist1) model(sem) fe type(ind, leeyu)
estimates store spe_panel_Dist1_ind
xsmle lnp_new $BESTX4, emat(W_Dist1) model(sem) fe type(both, leeyu)
estimates store spe_panel_Dist1_both

//Best Model + effects
xsmle lnp_new $BESTX4, wmat(W_Cont) model(sar) fe type(ind, leeyu) effects
estimates store sp_panel_cont_ind_eff


//cd "D:\Civil\Master\Ms.cTheses\Drafts\"
esttab nonsp_Panel nonsp_panel_time using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) replace

esttab sp_panel_Dist1_ind sp_panel_cont_ind sp_panel_knn5_ind using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) append

esttab sp_panel_Dist1_both sp_panel_cont_both sp_panel_knn5_both using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) append

esttab spe_panel_Dist1_ind spe_panel_cont_ind spe_panel_knn5_ind using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) append

esttab spe_panel_Dist1_both spe_panel_cont_both spe_panel_knn5_both using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) append

esttab nonsp_Panel sp_panel_cont_ind spe_panel_cont_ind using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) append

esttab sp_panel_cont_ind_eff using Ricardian_Paper.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.05 ** 0.01 *** 0.001) append
