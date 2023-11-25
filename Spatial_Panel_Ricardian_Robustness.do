	//////////////// This is code written in 1401/06/12 by SayedMorteza Malaekeh
//////////////// It is written to show if the results are robust
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
// W: row-standardized
// C: general-standardized
// Inverse Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\inverse_Weight_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Inverse m*
// Dist1 Matrix (147Km: each county at least one neighbor)
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\dist1_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Dist1 m*
// Dist2 Matrix (200Km)
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\dist200_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Dist2 m*
// Dist2 Matrix (250Km)
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\dist250_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Dist3 m*
// KNN5 Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\KNN5_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_KNN5 m*
// KNN7 Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\KNN7_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_KNN7 m*
// KNN10 Matrix
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\KNN10_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_KNN10 m*
// Contiguity Matrix (Row Normalized)
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\Cont_Weight_W_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Cont1 m*
// Contiguity Matrix (General Normalized)
import delimited "D:\Study\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix\Cont_Weight_C_Asc.csv", encoding(Big5) clear
Weight
spmat dta W_Cont2 m*

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
gen gdd8_squared = gdd8^2
gen logdensity_squared = logdensity^2
gen pr_g_squared = pr_g ^2
gen pr_ng_squared = pr_ng ^2
gen pr_t_squared = pr_t ^2
// Changing the Scale of Solar Radiation (To Million)
replace sr = sr/1000000
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
// Deflator
deflator
// Best Lists!
global BESTX gdd8 gdd8_squared gdd30 root_gdd34 pr_t sdii csdi gsl ncost logdensity  literacy_prob AD_Percent


**************************** Robustness1
// estimating different model 
xsmle lnp_new $BESTX, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store main_w_cont1
xsmle lnp_new $BESTX, wmat(W_Cont2) model(sar) fe type(ind, leeyu)
estimates store main_w_cont2
xsmle lnp_new $BESTX, wmat(W_Dist1) model(sar) fe type(ind, leeyu)
estimates store main_w_Dist1
xsmle lnp_new $BESTX, wmat(W_Dist2) model(sar) fe type(ind, leeyu)
estimates store main_w_Dist2
xsmle lnp_new $BESTX, wmat(W_Dist3) model(sar) fe type(ind, leeyu)
estimates store main_w_Dist3
xsmle lnp_new $BESTX, wmat(W_KNN5) model(sar) fe type(ind, leeyu)
estimates store main_w_KNN5
xsmle lnp_new $BESTX, wmat(W_KNN7) model(sar) fe type(ind, leeyu)
estimates store main_w_KNN7
xsmle lnp_new $BESTX, wmat(W_KNN10) model(sar) fe type(ind, leeyu)
estimates store main_w_KNN10
// changing the directory
cd "D:\Study\Master\Ms.cTheses\Publications\Ricardian Paper\Environmental and Resource Economics"
// making the table and extracting
esttab main_w_cont1 main_w_cont2 main_w_Dist1 main_w_Dist2 main_w_Dist3 main_w_KNN5 main_w_KNN7 main_w_KNN10 using Robustness.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.10 ** 0.05 *** 0.01) append

**************************** Robustness2
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table2_1
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t sdii csdi gsl, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table2_2
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table2_3
// changing the directory
cd "D:\Study\Master\Ms.cTheses\Publications\Ricardian Paper\Environmental and Resource Economics"
// making the table and extracting
esttab table2_1 table2_2 table2_3 using Robustness2.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.10 ** 0.05 *** 0.01) replace


**************************** Robustness3
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table3_1
// generating variables
gen gdd10_squared = gdd10^2
gen root_gdd37 = sqrt(gdd37)
// changing GDD10 and GDD37
xsmle lnp_new gdd10 gdd10_squared gdd30 root_gdd37 pr_t sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table3_2
// changing extreme indices
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t rx5 tn10p su ncost logdensity literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu)
// changing precipitation
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_g pr_ng sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
// adding precipitation squared
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t pr_t_squared sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table3_5 
// making the table and extracting
esttab table3_1 table3_2 table3_3 table3_4 table3_5 using Robustness2.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.10 ** 0.05 *** 0.01) replace

**************************** Robustness4
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table4_1
// wind speed
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t v sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table4_2
// solar radiation
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t sr sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table4_3
// surface air pressure
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t sar sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table4_4
// surface reservoir content
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t src sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table4_5
// albedo
xsmle lnp_new gdd8 gdd8_squared gdd30 root_gdd34 pr_t alb sdii csdi gsl ncost logdensity  literacy_prob AD_Percent, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
estimates store table4_6
// making the table and extracting
esttab table4_1 table4_2 table4_3 table4_4 table4_5 using Robustness2.rtf, aic bic r2 ar2 pr2 star nogap star(* 0.10 ** 0.05 *** 0.01) replace
**************************** Robustness5
xsmle lnp_new $BESTX, wmat(W_Cont1) model(sar) fe type(ind, leeyu) 
predict lnp_new_predicted, naive
predict lnp_new_predicted_rf
// twoway (kdensity lnp_new, lpattern(dot) lwidth(*2))(kdensity lnp_new_predicted, lpattern(dash)),legend(row(1) label(1 "True") label(2 "Estimated"))
twoway (kdensity lnp_new, lpattern(dot) lwidth(*2))(kdensity lnp_new_predicted_rf, lpattern(dash))(kdensity lnp_new_predicted), legend(row(1) label(1 "True") label(2 "Reduced form") label(3 "Naive"))
