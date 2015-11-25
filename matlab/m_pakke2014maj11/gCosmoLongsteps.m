function [c10Bes,c26Als,c21Nes,c14Cs,lump] = ...
    gCosmoLongsteps(ErateInt,ErateGla,tDegla,dtGla,dtIdtG,fixed_stuff);
%also saves concentration histories in "lump".
%gCosmoLongsteps2: Allows computation with fixed intervals
%Now, it is possible to compute the forward solution as a linear
%approximation:
switch fixed_stuff.testmode
  case 'fast',
    dtInt = dtGla*dtIdtG;
  case 'run_advec', %trim model to steplength in time
    disp('gCosmoLongstep called with mode run_advec. Takes a long time!')
    dt_advec = fixed_stuff.dt,
    tDegla = round(tDegla/dt_advec)*dt_advec,
    dtGla = round(dtGla/dt_advec)*dt_advec,
    dtInt = round(dtGla*dtIdtG/dt_advec)*dt_advec,
  case 'linearized'
    Gpr0 = fixed_stuff.Gpr0; %matrix of partial derivatives at or near maximum likelihood solution
    mpr0 = fixed_stuff.mpr0; %model at or near maximum likelihood solution
    dpr0 = fixed_stuff.dpr0; %proper g(m0)
    %>........ Model parameters. Her we may switch parameters on and off
    % fs.mname{1} = 'ErateInt';
    % fs.mname{2} = 'ErateGla';
    % fs.mname{3} = 'tDegla';
    % fs.mname{4} = 'dtGla';
    % fs.mname{5} = 'dtIdtG';
    for im=1:length(fixed_stuff.mname) %we pack elements of the m-vector:
      m(im,1) = eval(fixed_stuff.mname{im});
    end
    mpr = m2mpr(m,fixed_stuff);
    dpr = dpr0 + Gpr0*(mpr-mpr0);
    d = dpr2d(dpr,fixed_stuff);
    c10Bes = NaN*ones(size(fixed_stuff.zobs));
    c26Als = c10Bes; c21Nes = c10Bes; c14Cs = c10Bes;
    Nzobs = length(fixed_stuff.zobs);
    for iNucl = 1:length(fixed_stuff.Nucleides)
      switch fixed_stuff.Nucleides{iNucl}
        case '10Be', c10Bes = d((iNucl-1)*Nzobs + (1:Nzobs));%d=[d;cBes(:)];
        case '26Al', c26Als = d((iNucl-1)*Nzobs + (1:Nzobs));%d=[d;cAls(:)];
        case '21Ne', c21Nes = d((iNucl-1)*Nzobs + (1:Nzobs));%d=[d;cNes(:)];
        case '14C',  c14Cs  = d((iNucl-1)*Nzobs + (1:Nzobs));%d=[d;cCs(:)];
      end
    end
    lump.zss = [];
    lump.ts  = [];
    lump.ExposureTimeSinceNow = [];

    return
  otherwise,
    error('fixed_stuff,.testmode must be ''fast'' or ''run_advec'' or ''linearized''')
end


Period_gla = dtGla; %Names used i previous implementations and below
Period_int = dtInt; %Names used i previous implementations and below
erate_gla = ErateGla;
erate_int = ErateInt;

% Rock density in kg/m3
%rho = 2650;
rho = fixed_stuff.rho;

%Half lives
H10=1.39e6;
L10=log(2)/H10;
H26=0.705e6;
L26=log(2)/H26;
H14=5730;
L14=log(2)/H14;

%Absorption depth scale in kg/m2
Tau_spal=1600;
Tau_nm = 9900;
Tau_fm = 35000;

Tau_spal1=1570;
Tau_spal2=58.87;

Tau_nm1 = 1600;
Tau_nm2 = 10300;
Tau_nm3 = 30000;

Tau_fm1 = 1000;
Tau_fm2 = 15200;
Tau_fm3 = 76000;


a1 = 1.0747;
a2 = -0.0747;
b1 = -0.050;
b2 = 0.845;
b3 = 0.205;
c1 = 0.010;
c2 = 0.615;
c3 = 0.375;

%>>>BHJ: To be used in analytical expressions
% L_spal = Tau_spal/rho; %Decay depth, exp(-z/L)
% L_nm = Tau_nm/rho;
% L_fm = Tau_fm/rho;
%"K" in analytical expressions = P10_top_spal, etc.

%10Be production
% Input fra Kasper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - Start
%P10_top_spal=5.33e3; %atoms/kg/yr
%P10_top_nm=0.106e3; %atoms/kg/yr
P10_top_fm=0.093e3; %atoms/kg/yr
P10_top_spal = fixed_stuff.be_prod_spall;
P10_top_nm = fixed_stuff.be_prod_muons;

%Reference values for Kasper
%P10_top_spal=5.33e3; %atoms/kg/yr
%P10_top_nm=0.106e3; %atoms/kg/yr
%P10_top_fm=0.093e3; %atoms/kg/yr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - End

%P10_top_spal=5.33e3; %atoms/kg/yr
%P10_top_spal=4.76e3; %atoms/kg/yr

%P10_top_nm=0.106e3; %atoms/kg/yr
%P10_top_nm=0.959e3; %atoms/kg/yr

%P10_top_fm=0.093e3; %atoms/kg/yr
%P10_top_fm=0.084e3; %atoms/kg/yr

%Prodi rate for Corbett's sample GU110
%P10_top_spal=8.04e3; %atoms/kg/yr
%P10_top_nm=0.125e3; %atoms/kg/yr
%P10_top_fm=0.114e3; %atoms/kg/yr


% P10_spal = P10_top_spal*exp(-z*rho/Tau_spal);
% P10_nm = P10_top_nm*exp(-z*rho/Tau_nm);
% P10_fm = P10_top_fm*exp(-z*rho/Tau_fm);
% 
% P10_total = (P10_spal + P10_nm + P10_fm);

%26Al production

% Input fra Kasper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - Start
%P26_top_spal=31.1e3; %atoms/kg/yr
%P26_top_nm=0.7e3; %atoms/kg/yr
P26_top_fm=0.6e3; %atoms/kg/yr

P26_top_spal = fixed_stuff.al_prod_spall;
P26_top_nm = fixed_stuff.al_prod_muons;

%Reference values for Kasper
%P26_top_spal=31.1e3; %atoms/kg/yr
%P26_top_nm=0.7e3; %atoms/kg/yr
%P26_top_fm=0.6e3; %atoms/kg/yr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% - End

%P26_top_spal=31.1e3; %atoms/kg/yr
%P26_top_nm=0.7e3; %atoms/kg/yr
%P26_top_fm=0.6e3; %atoms/kg/yr

%P26_top_spal=54.25e3; %atoms/kg/yr
%P26_top_nm=1.074e3; %atoms/kg/yr
%P26_top_fm=0.923e3; %atoms/kg/yr

% P26_spal = P26_top_spal*exp(-z*rho/Tau_spal);
% P26_nm = P26_top_nm*exp(-z*rho/Tau_nm);
% P26_fm = P26_top_fm*exp(-z*rho/Tau_fm);
% 
% P26_total = (P26_spal + P26_nm + P26_fm);

%21Ne production
%P21_top_spal=20.8e3; %atoms/kg/yr
%P21_top_nm=0.4e3; %atoms/kg/yr
P21_top_fm=0.35e3; %atoms/kg/yr

P21_top_spal = fixed_stuff.ne_prod_spall;
P21_top_nm = fixed_stuff.ne_prod_muons;

% P21_spal = P21_top_spal*exp(-z*rho/Tau_spal);
% P21_nm = P21_top_nm*exp(-z*rho/Tau_nm);
% P21_fm = P21_top_fm*exp(-z*rho/Tau_fm);
% 
% P21_total = (P21_spal + P21_nm + P21_fm);

%14C production
%P14_top_spal=14.6e3; %atoms/kg/yr
%P14_top_nm=2.3e3; %atoms/kg/yr
P14_top_fm=2.1e3; %atoms/kg/yr

P14_top_spal = fixed_stuff.c_prod_spall;
P14_top_nm = fixed_stuff.c_prod_muons;

% P14_spal = P14_top_spal*exp(-z*rho/Tau_spal);
% P14_nm = P14_top_nm*exp(-z*rho/Tau_nm);
% P14_fm = P14_top_fm*exp(-z*rho/Tau_fm);
% 
% P14_total = (P14_spal + P14_nm + P14_fm);
%>>>>> BHJ: And now the analytical solution
%INPUTS:
% tau: Decay time of nucleide
% ts: End times of intervals. Normally ts(1)=0=now, and ts(2:end)<0, so
% that ts is a decreasing vector, going more and more negative.
% zs: Present lamina depths below present surface z=0.
% ers: ers(i) is the erosion rate in interval between ts(i) and ts(i+1),
% Ks: Ks(i) is the production rate in interval between ts(i) and ts(i+1)
% L: Penetration depth of radiation in play. dC/dt(z) = K*exp(-z/L)
%OUTPUTS:
%Css: Concentrations of nucleide. Css(it,iz) applies to ts(it) and zs(iz)
%zss,tss: depths and times so that mesh(zss,tss,Css) works.%The call:
%[Css,zss,tss] = C_all_intervals(ts,zs,Ks,tau,ers,L)

% ts = -fliplr(time); %First element in ts is the start of the model run
% zs = fixed_stuff.z;

%Setting up Gla/Int timing:

switch fixed_stuff.CycleMode
  case 'FixedC'
    if isempty('fixed_stuff.C')
      C=round((2.6e6-tDegla+dtGla*dtIdtG)/(dtGla*(1+dtIdtG)));
    else
      C=fixed_stuff.C; 
    end
    tstart_glacial = -tDegla+Period_int -(C:-1:1)*(Period_gla+Period_int);
    tend_glacial   = tstart_glacial + Period_gla;
  case 'FixedQuaternary'
    tQuat=-fixed_stuff.tQuaternary; %time of first glaciation, adjust as desired
    Cfloor=floor((2.6e6-tDegla+dtGla*dtIdtG)/(dtGla*(1+dtIdtG)));
    try
    tStartGlaRegular = -tDegla+Period_int -(Cfloor:-1:1)*(Period_gla+Period_int);
    catch
      keyboard
    end
    tStartIntRegular = tStartGlaRegular + Period_gla;
    dtFirstCycle = tStartGlaRegular(1)-tQuat;
    if dtFirstCycle<=0 %the regular cycles fitted the Quaternary exactly
      tstart_glacial = tStartGlaRegular;
      tend_glacial   = tStartIntRegular;
      C = Cfloor;
%       disp('FixedQuaternary: the regular cycles fitted the Quaternary exactly') 
    else
      dtFirstGla = dtFirstCycle / (1+dtIdtG);
      tstart_glacial = [tQuat,tStartGlaRegular];
      tend_glacial   = [tQuat+dtFirstGla,tStartIntRegular];
      C = Cfloor+1;
    end
  case 'FixedTimes'
    if any(isnan(fixed_stuff.tGal))
      error(['fixed_stuff.CycleMode=''FixedTimes'' not implemented yet'])
    else
      t_start_gla = fixed_stuff.tGlas; %load or compute fixed times of glaciation starts
      t_start_int = fixed_stuff.tInt; %load or compute fixed times of glaciation ends
    end
    C = length(t_start_gla);
  case 'd18OTimes'
      tStarts  = fixed_stuff.tStarts;
      relExpos = fixed_stuff.relExpos;
      relExpos(end+1) = 1;      % !!!!!! We hereby impose full exposure during the Holocene
      %d18Oth should not determine the "start of Holocene": update by tDegla
      tStarts(end+1) = -tDegla;
%     C = length(t_start_gla);
end
if strcmp(fixed_stuff.CycleMode,'d18OTimes')
  tsLong = [-inf,tStarts(:)',0];
  is_ints2 = relExpos; %If relExpos==1 then is_ints2 is 1, i.e. it is an interglacial
  is_ints2 = [1,is_ints2(:)']; %Exposed before the Quaternary
else %regular intervals
  tsLong = sort([-inf,tstart_glacial,tend_glacial,0]);
  is_ints2 = 0.5*(1 + -(-1).^(1:2*C+1)); %[1 0 1 0 ... 0 1]
end
ers2 = erate_int*is_ints2 + erate_gla*(1-is_ints2);

tau_10Be = 1/L10;
tau_26Al = 1/L26;
tau_21Ne = inf;
tau_14C = 1/L14;

L_spal = Tau_spal/rho; %Decay depth, exp(-z/L)
L_nm = Tau_nm/rho;
L_fm = Tau_fm/rho;

% is_ints(1) = 1; %Ice free before simulation period
% ers(1)= erate_int; %same as we used yo initiate the advective solution

K_10Be_spal = is_ints2*P10_top_spal;
K_10Be_nm   = is_ints2*P10_top_nm;
K_10Be_fm   = is_ints2*P10_top_fm;

K_26Al_spal = is_ints2*P26_top_spal;
K_26Al_nm   = is_ints2*P26_top_nm;
K_26Al_fm   = is_ints2*P26_top_fm;

K_21Ne_spal = is_ints2*P21_top_spal;
K_21Ne_nm   = is_ints2*P21_top_nm;
K_21Ne_fm   = is_ints2*P21_top_fm;

K_14C_spal  = is_ints2*P14_top_spal;
K_14C_nm    = is_ints2*P14_top_nm;
K_14C_fm    = is_ints2*P14_top_fm;

zobs = fixed_stuff.zobs;
% tic
%Model 10Be:
[Css_10Be_spal,zss,tss,ExposureTimeSinceNow] ...
                = C_all_intervals2(tsLong,zobs,K_10Be_spal,tau_10Be,ers2,L_spal);
[Css_10Be_nm  ] = C_all_intervals2(tsLong,zobs,K_10Be_nm  ,tau_10Be,ers2,L_nm  );
[Css_10Be_fm  ] = C_all_intervals2(tsLong,zobs,K_10Be_fm  ,tau_10Be,ers2,L_fm  );
c10Bes = Css_10Be_spal(:,end)+Css_10Be_nm(:,end)+Css_10Be_fm(:,end); 
% cBe_analyt = c10Be_prof(1);

%Model 26Al:
[Css_26Al_spal] = C_all_intervals2(tsLong,zobs,K_26Al_spal,tau_26Al,ers2,L_spal);
[Css_26Al_nm  ] = C_all_intervals2(tsLong,zobs,K_26Al_nm  ,tau_26Al,ers2,L_nm  );
[Css_26Al_fm  ] = C_all_intervals2(tsLong,zobs,K_26Al_fm  ,tau_26Al,ers2,L_fm  );
c26Als = Css_26Al_spal(:,end)+Css_26Al_nm(:,end)+Css_26Al_fm(:,end); 
% cAl_analyt = c26Al_prof(1);

%Model 21Ne:
[Css_21Ne_spal] = C_all_intervals2(tsLong,zobs,K_21Ne_spal,tau_21Ne,ers2,L_spal);
[Css_21Ne_nm  ] = C_all_intervals2(tsLong,zobs,K_21Ne_nm  ,tau_21Ne,ers2,L_nm  );
[Css_21Ne_fm  ] = C_all_intervals2(tsLong,zobs,K_21Ne_fm  ,tau_21Ne,ers2,L_fm  );
c21Nes = Css_21Ne_spal(:,end)+Css_21Ne_nm(:,end)+Css_21Ne_fm(:,end); 
% cNe_analyt = c21Ne_prof(1);

%Model 14C:
[Css_14C_spal] = C_all_intervals2(tsLong,zobs,K_14C_spal,tau_14C,ers2,L_spal);
[Css_14C_nm  ] = C_all_intervals2(tsLong,zobs,K_14C_nm  ,tau_14C,ers2,L_nm  );
[Css_14C_fm  ] = C_all_intervals2(tsLong,zobs,K_14C_fm  ,tau_14C,ers2,L_fm  );
c14Cs = Css_14C_spal(:,end)+Css_14C_nm(:,end)+Css_14C_fm(:,end); 
% cC_analyt = c14C_prof(1);

if nargout==5 
  lump.zss = zss;
  lump.ts = tss(1,:);
  lump.ExposureTimeSinceNow =ExposureTimeSinceNow;
  lump.c14Css = Css_14C_spal+Css_14C_nm+Css_14C_fm; 
  lump.c10Bess = Css_10Be_spal+Css_10Be_nm+Css_10Be_fm; 
  lump.c26Alss = Css_26Al_spal+Css_26Al_nm+Css_26Al_fm; 
  lump.c21Ness = Css_21Ne_spal+Css_21Ne_nm+Css_21Ne_fm; 
end
% disp(['analyt time:']); toc

switch fixed_stuff.testmode
    case 'fast', return
    case 'run_advec', %just go on
    otherwise,
        error('fixed_stuff,.testmode must be ''fast'' or ''run_advec''')
end

% error('fast did not return')
%#####################********************################
%    Start of optional advective solution
%#####################********************################

D = fixed_stuff.D;
z = fixed_stuff.z;

% Rock density in kg/m3
rho = 2650;

%Half lives
H10=1.39e6;
L10=log(2)/H10;

H26=0.705e6;
L26=log(2)/H26;

H14=5730;
L14=log(2)/H14;

%Absorption depth scale in kg/m2
Tau_spal=1600;
Tau_nm = 9900;
Tau_fm = 35000;

%>>>BHJ: To be used in analytical expressions
% L_spal = Tau_spal/rho; %Decay depth, exp(-z/L)
% L_nm = Tau_nm/rho;
% L_fm = Tau_fm/rho;
%"K" in analytical expressions = P10_top_spal, etc.

%10Be production
P10_top_spal=5.33e3; %atoms/kg/yr
%P10_top_spal=4.76e3; %atoms/kg/yr

P10_top_nm=0.106e3; %atoms/kg/yr
%P10_top_nm=0.959e3; %atoms/kg/yr

P10_top_fm=0.093e3; %atoms/kg/yr
%P10_top_fm=0.084e3; %atoms/kg/yr

P10_spal = P10_top_spal*exp(-z*rho/Tau_spal);
P10_nm = P10_top_nm*exp(-z*rho/Tau_nm);
P10_fm = P10_top_fm*exp(-z*rho/Tau_fm);

%P10_spal = P10_top_spal*(a1*exp(-z*rho/Tau_spal1)+a2*exp(-z*rho/Tau_spal2));
%P10_nm = P10_top_nm*(b1*exp(-z*rho/Tau_nm1)+b2*exp(-z*rho/Tau_nm2)+b3*exp(-z*rho/Tau_nm3));
%P10_fm = P10_top_fm*(c1*exp(-z*rho/Tau_fm1)+c2*exp(-z*rho/Tau_fm2)+c3*exp(-z*rho/Tau_fm3));

P10_total = (P10_spal + P10_nm + P10_fm);

%26Al production
P26_top_spal=31.1e3; %atoms/kg/yr
P26_top_nm=0.7e3; %atoms/kg/yr
P26_top_fm=0.6e3; %atoms/kg/yr

P26_spal = P26_top_spal*exp(-z*rho/Tau_spal);
P26_nm = P26_top_nm*exp(-z*rho/Tau_nm);
P26_fm = P26_top_fm*exp(-z*rho/Tau_fm);

P26_total = (P26_spal + P26_nm + P26_fm);

%21Ne production
P21_top_spal=20.8e3; %atoms/kg/yr
P21_top_nm=0.4e3; %atoms/kg/yr
P21_top_fm=0.35e3; %atoms/kg/yr

P21_spal = P21_top_spal*exp(-z*rho/Tau_spal);
P21_nm = P21_top_nm*exp(-z*rho/Tau_nm);
P21_fm = P21_top_fm*exp(-z*rho/Tau_fm);

P21_total = (P21_spal + P21_nm + P21_fm);

%14C production
P14_top_spal=14.6e3; %atoms/kg/yr
P14_top_nm=2.3e3; %atoms/kg/yr
P14_top_fm=2.1e3; %atoms/kg/yr

P14_spal = P14_top_spal*exp(-z*rho/Tau_spal);
P14_nm = P14_top_nm*exp(-z*rho/Tau_nm);
P14_fm = P14_top_fm*exp(-z*rho/Tau_fm);

P14_total = (P14_spal + P14_nm + P14_fm);


%Starting concentrations, equilibrium since eternity
%This is computed as integrated part of the analytical solution
switch fixed_stuff.Cstart
    case 'from dat',
        C10start = fixed_stuff.C10_start;
        C26start = fixed_stuff.C26_start;
        C21start = fixed_stuff.C21_start;
        C14start = fixed_stuff.C14_start;
    case 'extend interglacial'
        %Making the start profile a "fm" steady state profile:
        ers = erate_int; %assume non-glaciated start conditions

        [C10_steady_spal] = Lal2002eq8(z,P10_top_spal,L10,rho,Tau_spal,ers);
        [C10_steady_nm] = Lal2002eq8(z,P10_top_nm,  L10,rho,Tau_nm,  ers);
        [C10_steady_fm] = Lal2002eq8(z,P10_top_fm,  L10,rho,Tau_fm,  ers);
        C10start = C10_steady_spal +C10_steady_nm +C10_steady_fm;

        [C26_steady_spal] = Lal2002eq8(z,P26_top_spal,L26,rho,Tau_spal,ers);
        [C26_steady_nm] = Lal2002eq8(z,P26_top_nm,  L26,rho,Tau_nm,  ers);
        [C26_steady_fm] = Lal2002eq8(z,P26_top_fm,  L26,rho,Tau_fm,  ers);
        C26start = C26_steady_spal +C26_steady_nm +C26_steady_fm;

        L21 = 0; %stable
        [C21_steady_spal] = Lal2002eq8(z,P21_top_spal,L21,rho,Tau_spal,ers);
        [C21_steady_nm] = Lal2002eq8(z,P21_top_nm,  L21,rho,Tau_nm,  ers);
        [C21_steady_fm] = Lal2002eq8(z,P21_top_fm,  L21,rho,Tau_fm,  ers);
        C21start = C21_steady_spal +C21_steady_nm +C21_steady_fm;

        [C14_steady_spal] = Lal2002eq8(z,P14_top_spal,L14,rho,Tau_spal,ers);
        [C14_steady_nm] = Lal2002eq8(z,P14_top_nm,  L14,rho,Tau_nm,  ers);
        [C14_steady_fm] = Lal2002eq8(z,P14_top_fm,  L14,rho,Tau_fm,  ers);
        C14start = C14_steady_spal +C14_steady_nm +C14_steady_fm;
    case 'zeros'
        C10start = zeros(size(z));
        C26start = C10start; C21start = C10start; C14start = C10start;
end
C10 = C10start;
C26 = C26start;
C21 = C21start;
C14 = C14start;

% Number of glacial-interglacial cycles
% C = 1;
C = fixed_stuff.C;

for i=1:C;
    gla_init(i) = (Period_gla*i-Period_gla)+(Period_int*i-Period_int);
    gla_end(i) = (Period_gla*i)+(Period_int*i-Period_int);
    
    gla_hist_for((2*i)-1) = gla_init(i);
    gla_hist_for(2*i) = gla_end(i);
end

l = 1;  %<----------------- beware of l and 1 
gla_hist(:,l) = gla_hist_for; 




time_gla(l) = Period_gla;
time_int(l) = Period_int;

dt = fixed_stuff.dt; %time step. 
%Note that in gcosmo_advec.m glaciations must be full multiples of dt.
%Here, in gcosmo_analyt this is not required.

%Number of timesteps
%Bem?rk, her tilf?jes "Holoc?n", s? det an bekvemt v?re tDegla
% ts(l) = (gla_hist(end,l)+Period_int)/dt;
ts(l) = (gla_hist(end,l)+tDegla)/dt;

time(1) = 0; 

P10_total_decay = P10_total*dt*exp(-L10*dt);

P26_total_decay = P26_total*dt*exp(-L26*dt);

P21_total_decay = P21_total*dt;

P14_total_decay = P14_total*dt*exp(-L14*dt);

tic %advec
for i=1:ts(l),
   
 D10 = C10*L10*dt;
 S10_int = P10_total_decay(:) - D10(:);
 S10_gla = -D10;
 
 D26 = C26*L26*dt;
 S26_int = P26_total_decay(:) - D26(:);
 S26_gla = -D26;
 
 D21 = zeros(size(z))';
 S21_int = P21_total_decay(:) - D21(:);
 S21_gla = -D21;
 
 D14 = C14*L14*dt;
 S14_int = P14_total_decay(:) - D14(:);
 S14_gla = -D14;
    
    time(i+1) = dt*i; 
    
  
    for j=1:2:length(gla_hist(:,l))
       if time(i) >= gla_hist(j,l);
        erate = erate_gla(l);
        S10 = S10_gla;
        S26 = S26_gla;
        S21 = S21_gla;
        S14 = S14_gla;
        is_int = 0; %<<<< BHJ
      end
    
      if time(i) >= gla_hist(j+1,l);
       erate = erate_int(l);
       S10 = S10_int;
       S26 = S26_int;
       S21 = S21_int;
       S14 = S14_int;
       is_int = 1; %<<<< BHJ
      end
    end
 
   
erosion(i) = erate;
is_ints(i+1) = is_int; 

C10 = update_profile(C10,z,S10,erate,dt);
C26 = update_profile(C26,z,S26,erate,dt);
C21 = update_profile(C21,z,S21,erate,dt);
C14 = update_profile(C14,z,S14,erate,dt);

% try
% C10 = update_profile_dummy(C10,z,S10,erate,dt); %disp(['C10, i=',num2str(i)])
% C26 = update_profile_dummy(C26,z,S26,erate,dt); %disp(['C26, i=',num2str(i)])
% C21 = update_profile_dummy(C21,z,S21,erate,dt); %disp(['C21, i=',num2str(i)])
% C14 = update_profile_dummy(C14,z,S14,erate,dt); %disp(['C14, i=',num2str(i)])
% catch
%     keyboard
% end
D10_top(i) = D10(1);
S10_top(i) = S10(1);
C10_top(i) = C10(1);

D26_top(i) = D26(1);
S26_top(i) = S26(1);
C26_top(i) = C26(1);

D21_top(i) = D21(1);
S21_top(i) = S21(1);
C21_top(i) = C21(1);

D14_top(i) = D14(1);
S14_top(i) = S14(1);
C14_top(i) = C14(1);

%line(C10,z,'color','r');

%>>>> BHJ: Pack valus for subsequent analytical run
%L_spal, L_nm and L_rm were defined above
%{
K_10Be_spal(i+1) = P10_top_spal;
K_10Be_nm(i+1)   = P10_top_nm;
K_10Be_fm(i+1)   = P10_top_fm;

K_26Al_spal(i+1) = P26_top_spal;
K_26Al_nm(i+1)   = P26_top_nm;
K_26Al_fm(i+1)   = P26_top_fm;

K_21Ne_spal(i+1) = P21_top_spal;
K_21Ne_nm(i+1)   = P21_top_nm;
K_21Ne_fm(i+1)   = P21_top_fm;

K_14C_spal(i+1)  = P14_top_spal;
K_14C_nm(i+1)    = P14_top_nm;
K_14C_fm(i+1)    = P14_top_fm;
%}
ers(i+1) = erate;

end;

t_time(l) = time((C*Period_gla+(C-1)*Period_int+tDegla)/dt+1); 

D10_top = D10_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
S10_top = S10_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
C10_top = C10_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);

D26_top = D26_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
S26_top = S26_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
C26_top = C26_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);

D21_top = D21_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
S21_top = S21_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
C21_top = C21_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);

D14_top = D14_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
S14_top = S14_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);
C14_top = C14_top(1:(C*Period_gla+(C-1)*Period_int+tDegla)/dt);

%Concentration in top node at the end of the last interglacia
eval(['C10_top_p',num2str(l),'= C10_top(end);']);
eval(['C26_top_p',num2str(l),'= C26_top(end);']);
eval(['C21_top_p',num2str(l),'= C21_top(end);']);
eval(['C14_top_p',num2str(l),'= C14_top(end);']);

%The output values cNe,cC,cAl,CBe:
cBe = C10_top(end);
cAl = C26_top(end);
cNe = C21_top(end);
cC = C14_top(end);

disp(['advec time:']); toc
tic %analyt
%>>>>> BHJ: And now the analytical solution
%INPUTS:
% tau: Decay time of nucleide
% ts: End times of intervals. Normally ts(1)=0=now, and ts(2:end)<0, so
% that ts is a decreasing vector, going more and more negative.
% zs: Present lamina depths below present surface z=0.
% ers: ers(i) is the erosion rate in interval between ts(i) and ts(i+1),
% Ks: Ks(i) is the production rate in interval between ts(i) and ts(i+1)
% L: Penetration depth of radiation in play. dC/dt(z) = K*exp(-z/L)
%OUTPUTS:
%Css: Concentrations of nucleide. Css(it,iz) applies to ts(it) and zs(iz)
%zss,tss: depths and times so that mesh(zss,tss,Css) works.%The call:
%[Css,zss,tss] = C_all_intervals(ts,zs,Ks,tau,ers,L)

ts = -fliplr(time); %First element in ts is the start of the model run
zs = z;

%Timing of constant intervals:
%An infinite "interglacial" followed by C glaciations and C interglacials
tstart_glacial = -(C:-1:1)*(Period_gla+Period_int);
tend_glacial   = tstart_glacial + Period_gla;
t_bounds = sort([-inf,tstart_glacial,tend_glacial,0]);
is_ints2 = 0.5*(1 + (-1).^(1:2*C+1)); %[1 0 1 0 ... 0 1]

ers2 = erate_int*is_ints2 + erate_gla*(1-is_ints2);

tau_10Be = 1/L10;
tau_26Al = 1/L26;
tau_21Ne = inf;
tau_14C = 1/L14;

L_spal = Tau_spal/rho; %Decay depth, exp(-z/L)
L_nm = Tau_nm/rho;
L_fm = Tau_fm/rho;

is_ints(1) = 1; %Ice free before simulation period
ers(1)= erate_int; %same as we used yo initiate the advective solution

K_10Be_spal = is_ints*P10_top_spal;
K_10Be_nm   = is_ints*P10_top_nm;
K_10Be_fm   = is_ints*P10_top_fm;

K_26Al_spal = is_ints*P26_top_spal;
K_26Al_nm   = is_ints*P26_top_nm;
K_26Al_fm   = is_ints*P26_top_fm;

K_21Ne_spal = is_ints*P21_top_spal;
K_21Ne_nm   = is_ints*P21_top_nm;
K_21Ne_fm   = is_ints*P21_top_fm;

K_14C_spal  = is_ints*P14_top_spal;
K_14C_nm    = is_ints*P14_top_nm;
K_14C_fm    = is_ints*P14_top_fm;

tic
%Model 10Be:
[Css_10Be_spal,zss,tss] = C_all_intervals(ts,zs,K_10Be_spal,tau_10Be,ers,L_spal);
[Css_10Be_nm  ,zss,tss] = C_all_intervals(ts,zs,K_10Be_nm  ,tau_10Be,ers,L_nm  );
[Css_10Be_fm  ,zss,tss] = C_all_intervals(ts,zs,K_10Be_fm  ,tau_10Be,ers,L_fm  );
c10Be_prof = Css_10Be_spal(:,end)+Css_10Be_nm(:,end)+Css_10Be_fm(:,end); 
cBe_analyt = c10Be_prof(1);

%Model 26Al:
[Css_26Al_spal,zss,tss] = C_all_intervals(ts,zs,K_26Al_spal,tau_26Al,ers,L_spal);
[Css_26Al_nm  ,zss,tss] = C_all_intervals(ts,zs,K_26Al_nm  ,tau_26Al,ers,L_nm  );
[Css_26Al_fm  ,zss,tss] = C_all_intervals(ts,zs,K_26Al_fm  ,tau_26Al,ers,L_fm  );
c26Al_prof = Css_26Al_spal(:,end)+Css_26Al_nm(:,end)+Css_26Al_fm(:,end); 
cAl_analyt = c26Al_prof(1);

%Model 21Ne:
[Css_21Ne_spal,zss,tss] = C_all_intervals(ts,zs,K_21Ne_spal,tau_21Ne,ers,L_spal);
[Css_21Ne_nm  ,zss,tss] = C_all_intervals(ts,zs,K_21Ne_nm  ,tau_21Ne,ers,L_nm  );
[Css_21Ne_fm  ,zss,tss] = C_all_intervals(ts,zs,K_21Ne_fm  ,tau_21Ne,ers,L_fm  );
c21Ne_prof = Css_21Ne_spal(:,end)+Css_21Ne_nm(:,end)+Css_21Ne_fm(:,end); 
cNe_analyt = c21Ne_prof(1);

%Model 14C:
[Css_14C_spal,zss,tss] = C_all_intervals(ts,zs,K_14C_spal,tau_14C,ers,L_spal);
[Css_14C_nm  ,zss,tss] = C_all_intervals(ts,zs,K_14C_nm  ,tau_14C,ers,L_nm  );
[Css_14C_fm  ,zss,tss] = C_all_intervals(ts,zs,K_14C_fm  ,tau_14C,ers,L_fm  );
c14C_prof = Css_14C_spal(:,end)+Css_14C_nm(:,end)+Css_14C_fm(:,end); 
cC_analyt = c14C_prof(1);

disp(['analyt time:']); toc

%Now compare results:
[cBe,cBe_analyt;...
 cAl,cAl_analyt;...
 cNe,cNe_analyt;...
 cC,cC_analyt]
rel_error=[(cBe-cBe_analyt)/cBe;...
 (cAl-cAl_analyt)/cAl;...
 (cNe-cNe_analyt)/cNe;...
 (cC-cC_analyt)/cC]

figure; set(gcf,'name','AdvecSurface vs AnalyTrace')
subplot(2,2,1)
plot(ts(2:end),(Css_10Be_fm(1,2:end)+Css_10Be_nm(1,2:end)+Css_10Be_spal(1,2:end)),'.')
hold on
plot(ts(2:end),C10_top,'-')
title('10Be')
legend('Analy','Advec','Location','Northwest')

subplot(2,2,2)
plot(ts(2:end),(Css_26Al_fm(1,2:end)+Css_26Al_nm(1,2:end)+Css_26Al_spal(1,2:end)),'.')
hold on
plot(ts(2:end),C26_top,'-')
title('26Al')
legend('Analy','Advec','Location','Northwest')

subplot(2,2,3)
plot(ts(2:end),(Css_21Ne_fm(1,2:end)+Css_21Ne_nm(1,2:end)+Css_21Ne_spal(1,2:end)),'.')
hold on
plot(ts(2:end),C21_top,'-')
title('21Ne')
legend('Analy','Advec','Location','Northwest')

subplot(2,2,4)
plot(ts(2:end),(Css_14C_fm(1,2:end)+Css_14C_nm(1,2:end)+Css_14C_spal(1,2:end)),'.')
hold on
plot(ts(2:end),C14_top,'-')
title('14C')
legend('Analy','Advec','Location','Northwest')

figure; set(gcf,'name','(Adv-Ana)/Adv')
subplot(2,2,1)
plot(ts(2:end),(Css_10Be_fm(1,2:end)+Css_10Be_nm(1,2:end)+Css_10Be_spal(1,2:end))./C10_top,'.')
title('10Be')

subplot(2,2,2)
plot(ts(2:end),(Css_26Al_fm(1,2:end)+Css_26Al_nm(1,2:end)+Css_26Al_spal(1,2:end))./C26_top,'.')
hold on
title('26Al')

subplot(2,2,3)
plot(ts(2:end),(Css_21Ne_fm(1,2:end)+Css_21Ne_nm(1,2:end)+Css_21Ne_spal(1,2:end))./C10_top,'.')
hold on
title('21Ne')

subplot(2,2,4)
plot(ts(2:end),(Css_14C_fm(1,2:end)+Css_14C_nm(1,2:end)+Css_14C_spal(1,2:end))./C14_top,'.')
hold on
title('14C')

figure; set(gcf,'name','Compare c(z,t=0)')
subplot(2,2,1)
plot(zs,c10Be_prof,'.g'); hold on %analyt
plot(zs,C10,'.m'); %advec
plot(zs,C10start,'-b'); %advec
title('10Be(z), t=0')
xlabel('Depth [m]')

subplot(2,2,2)
plot(zs,c26Al_prof,'.g'); hold on  %analyt
plot(zs,C26,'.m'); %advec
plot(zs,C26start,'-b'); %advec
title('26Al(z), t=0')
xlabel('Depth [m]')

subplot(2,2,3)
plot(zs,c21Ne_prof,'.g'); hold on  %analyt
plot(zs,C21,'.m') %advec
plot(zs,C21start,'-b'); %advec
title('21Ne(z), t=0')
xlabel('Depth [m]')

subplot(2,2,4)
plot(zs,c14C_prof,'.g'); hold on  %analyt
plot(zs,C14,'.m'); %advec
plot(zs,C14start,'-b'); %advec
title('14C(z), t=0')
xlabel('Depth [m]')

%And now make check plots of (zobs,cBes) etc.
subplot(2,2,1)
plot(zobs,c10Bes,'*')
subplot(2,2,2)
plot(zobs,c26Als,'*')
subplot(2,2,3)
plot(zobs,c21Nes,'*')
subplot(2,2,4)
plot(zobs,c14Cs,'*')

% figure; set(gcf,'name','(Adv-Ana)/Adv')
% subplot(2,2,1)
% plot(ts(2:end),(Css_14C_fm(1,2:end)+Css_14C_nm(1,2:end)+Css_14C_spal(1,2:end))./C14_top,'.g')
keyboard
%erosion = erosion(1:(C*Period_gla+C*Period_int)/dt);

%C10_C26_top = -1*zeros((5*max(P_gla)+5*max(P_int))/100,l);
%C10_C26_top(:,l) = C10_top./C26_top;
%eval(['C10_C26_top_',num2str(l),'= C10_top./C26_top;']);

%C14_C10_top(:,l) = C14_top./C10_top;
%eval(['C14_C10_top_',num2str(l),'= C14_top./C10_top;']);

%C10_C21_top = -1*zeros((5*max(P_gla)+5*max(P_int))/100,l);
%C10_C21_top(:,l) = C10_top./C21_top;
%eval(['C10_C21_top_',num2str(l),'= C10_top./C21_top;']);

%C14_C26_top = -1*zeros((5*max(P_gla)+5*max(P_int))/100,l);
%C14_C26_top(:,l) = C14_top./C26_top;
%eval(['C14_C26_top_',num2str(l),'= C14_top./C26_top;']);

%C26_C21_top = -1*zeros((5*max(P_gla)+5*max(P_int))/100,l);
%C26_C21_top(:,l) = C26_top./C21_top;
%eval(['C26_C21_top_',num2str(l),'= C26_top./C21_top;']);

%C14_C21_top = -1*zeros((5*max(P_gla)+5*max(P_int))/100,l);
%C14_C21_top(:,l) = C14_top./C21_top;
%eval(['C14_C21_top_',num2str(l),'= C14_top./C21_top;']);


%eval(['erosion_hist_',num2str(l),'= erosion(:);']);
return
end 


function C_out = update_profile_dummy(C,z,S,erate,dt);
C_out=C+S;
end