function [P10_top_spal,P10_top_nm,P10_top_fm,P26_top_spal,P26_top_nm,P26_top_fm,Tau10_nm_mcmc,Tau10_fm_mcmc,Tau26_nm_mcmc,Tau26_fm_mcmc]=calculate_production_rates(rho,elevation,mean_thick,P10_top_spal_Cronus,P10_top_muon_Cronus,P26_top_spal_Cronus,P26_top_muon_Cronus);

%Constants relevant for the calculations of muonic production rates are imported
load al_be_consts_v23.mat

%Convert elevation to atm pressure (hPa)
p = 1013.25*(1-2.25577e-5*elevation)^5.25588;

%Define depths below surface z/rho cm/(g/cm3)
D_m =100; %Depth
z_m = linspace(0,10,100);
z_D = D_m*z_m.^3/10*rho;

P10_mu_total_Cronus = P_mu_total(z_D,p,al_be_consts,'no');
P26_mu_total_Cronus = P26_mu_total(z_D,p,al_be_consts,'no');

%The muonuc production rate is found
%Ratios of production by negative muons to fast muons are defined for both
%10Be and 26Al
nm_rat10 = 0.1070/(0.1070+0.0940);
fm_rat10 = 0.0940/(0.1070+0.0940);
nm_rat26 = 0.7/(0.7+0.6);
fm_rat26 = (0.6/(0.7+0.6));

%Muonic production rates defined
P10_top_nm = P10_mu_total_Cronus(1)*nm_rat10;
P10_top_fm = P10_mu_total_Cronus(1)*fm_rat10;
P26_top_nm = P26_mu_total_Cronus(1)*nm_rat26;
P26_top_fm = P26_mu_total_Cronus(1)*fm_rat26;

%Attenuations lengths are proposed
Nsim = 25000;
Tau10_nm_mcmc = 100 + (1500-100).*rand(Nsim,1);
Tau10_fm_mcmc = 500 + (15000-500).*rand(Nsim,1);
Tau26_nm_mcmc = 100 + (1500-100).*rand(Nsim,1);
Tau26_fm_mcmc = 500 + (15000-500).*rand(Nsim,1);

%The best fitting attenuation lengths are found
for i=1:Nsim
    P10_nm_mcmc(:,i) = P10_top_nm*exp(-z_D/Tau10_nm_mcmc(i));
    P10_fm_mcmc(:,i) = P10_top_fm*exp(-z_D/Tau10_fm_mcmc(i));
    P10_MCMC_Total_mcmc(:,i) = P10_nm_mcmc(:,i) + P10_fm_mcmc(:,i);
 
    P26_nm_mcmc(:,i) = P26_top_nm*exp(-z_D/Tau26_nm_mcmc(i));
    P26_fm_mcmc(:,i) = P26_top_fm*exp(-z_D/Tau26_fm_mcmc(i));
    P26_MCMC_Total_mcmc(:,i) = P26_nm_mcmc(:,i) + P26_fm_mcmc(:,i);
    
    k10_diff(i) = sqrt(sum((P10_mu_total_Cronus' - P10_MCMC_Total_mcmc(:,i)).^2));
    k26_diff(i) = sqrt(sum((P26_mu_total_Cronus' - P26_MCMC_Total_mcmc(:,i)).^2));
end

k10 = find(k10_diff == min(k10_diff));
k26 = find(k26_diff == min(k26_diff));

P10_nm_LS = P10_top_nm*exp(-z_D/Tau10_nm_mcmc(k10));
 P10_fm_LS = P10_top_fm*exp(-z_D/Tau10_fm_mcmc(k10));
 P10_MCMC_Total_LS = P10_nm_LS + P10_fm_LS;
 
 P26_nm_LS = P26_top_nm*exp(-z_D/Tau26_nm_mcmc(k26));
 P26_fm_LS = P26_top_fm*exp(-z_D/Tau26_fm_mcmc(k26));
 P26_MCMC_Total_LS = P26_nm_LS + P26_fm_LS;
 

 shield_fac_spal = exp(-mean_thick*rho/160);

shield_fac10_nm = exp(-mean_thick*rho/Tau10_nm_mcmc(k10));
shield_fac10_fm = exp(-mean_thick*rho/Tau10_fm_mcmc(k10));

shield_fac26_nm = exp(-mean_thick*rho/Tau26_nm_mcmc(k26));
shield_fac26_fm = exp(-mean_thick*rho/Tau26_fm_mcmc(k26));

P10_top_spal=P10_top_spal_Cronus*shield_fac_spal; %Spallation production rate (at/kg/yr)
P10_top_nm = P10_top_muon_Cronus*nm_rat10*shield_fac10_nm;
P10_top_fm = P10_top_muon_Cronus*fm_rat10*shield_fac10_fm;

P26_top_spal=P26_top_spal_Cronus*shield_fac_spal; %Spallation production rate (at/kg/yr) 
P26_top_nm = P26_top_muon_Cronus*nm_rat26*shield_fac26_nm;
P26_top_fm = P26_top_muon_Cronus*fm_rat26*shield_fac10_fm;

Tau10_nm_mcmc = Tau10_nm_mcmc(k10)*10;
Tau10_fm_mcmc = Tau10_fm_mcmc(k10)*10;

Tau26_nm_mcmc = Tau26_nm_mcmc(k26)*10;
Tau26_fm_mcmc = Tau26_fm_mcmc(k26)*10;