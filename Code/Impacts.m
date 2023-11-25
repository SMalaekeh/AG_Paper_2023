%% This code calculates the impacts of climate change in 2050 and 2080 1400/08/15 S.M.Malaekh
% Riding the Weighting Matrix
clear;clc;
cd 'D:\Civil\Master\Ms.cTheses\Data\Ricardian\Weight_Matrix'
Cont = csvread("Cont_Weight_W_Asc.csv");
Cont = Cont(2:end,2:end);
I = eye(315,315);
% Coefficients
rho = 0.406; 
% GDD8, GDD8_S, GDD30, GDD34_R, Pr_T, CSDI, SDII, GSL
beta = [0.0138,-0.0000159,0.0539,-0.525,0.0464,-0.135,-1.093,0.0284];
        % H = inv(1-rho*Cont)*(beta*I);
% Calculating the Inverse Matrix
H = (I + rho*Cont + rho^2*Cont^2 + rho^3*Cont^3 + rho^4*Cont^4 + ...
     rho^5*Cont^5 + rho^6*Cont^6 + rho^7*Cont^7);
%% Calculating the changes in the DX
% reading the county and forecast data
load('D:\Civil\Master\Ms.cTheses\Data\Forecast\Forecast.mat')
forecast = BaseRicardianClimateS2; clear BaseRicardianClimateS2;
load('D:\Civil\Master\Ms.cTheses\Data\Forecast\county.mat')
% calling DX_Calculator function
cd 'D:\Civil\Master\Ms.cTheses\Results and Codes\Ricardian Paper'
county = table2array(county); county = county(:,[1,9]);
% running the function DX_Calculator
DX = DX_Calculator(county,forecast,12);
% estimation of changes for each county
%% Calculating the Damage
change_gdd8 = (H *(beta(1)*I))*DX(:,3);
change_gdd8S = (H *(beta(2)*I))*DX(:,4);
change_gdd30 = (H *(beta(3)*I))*DX(:,5);
change_Rgdd34 = (H *(beta(4)*I))*DX(:,6);
change_prt = (H *(beta(5)*I))*DX(:,7);
change_csdi = (H *(beta(6)*I))*DX(:,8);
change_sdii = (H *(beta(7)*I))*DX(:,9);
change_gsl = (H *(beta(8)*I))*DX(:,10);
% calculating the total damage
change_tot = change_csdi + change_gdd30 + change_gdd8 + change_gdd8S + ...
    change_gsl + change_prt + change_Rgdd34 + change_sdii;
% adding the code and state
change_tot = [county, change_tot];
% saving to a excel
csvwrite('ce_12.csv',change_tot);
% dy = 100*(exp(change_tot) - 1);
%% Calculating the impacts
Hdiag = diag(change);
DIRECT = mean(Hdiag(:));
INDIRECT = mean(sum(change,2)) - DIRECT;
TOTAL = DIRECT + INDIRECT;
